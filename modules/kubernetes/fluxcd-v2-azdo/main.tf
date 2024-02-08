/**
 * # Flux V2
 *
 * Installs and configures [flux2](https://github.com/fluxcd/flux2) with Azure DevOps.
 *
 * The module is meant to offer a full bootstrap and confiugration of a Kubernetes cluster
 * with Fluxv2. A "root" repository is created for the bootstrap configuration along with a
 * repository per namepsace passed in the variables. The root repository will receive `cluster-admin`
 * permissions in the cluster while each of the namespace repositories will be limited to their
 * repsective namespace. The CRDs, component deployments and bootstrap configuration are both
 * added to the Kubernetes cluster and commited to the root repository. While the namespace
 * configuration is only comitted to the root repository and expected to be reconciled through
 * the bootstrap configuration.
 *
 * ![flux-arch](../../../assets/fluxcd-v2.jpg)
 */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.25.3"
    }
    azuredevops = {
      source  = "xenitab/azuredevops"
      version = "0.5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

locals {
  git_auth_proxy_url = "http://git-auth-proxy.flux-system.svc.cluster.local"
}

resource "kubernetes_namespace" "this" {
  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations,
    ]
  }

  metadata {
    name = "flux-system"
    labels = {
      name = "flux-system"
    }
  }
}

# Git Auth Proxy
resource "helm_release" "git_auth_proxy" {
  chart       = "oci://ghcr.io/xenitab/helm-charts/git-auth-proxy"
  name        = "git-auth-proxy"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "v0.8.2"
  max_history = 3
  values = [templatefile("${path.module}/templates/git-auth-proxy-values.yaml.tpl", {
    azure_devops_pat  = var.azure_devops_pat,
    azure_devops_org  = var.azure_devops_org,
    azure_devops_proj = var.azure_devops_proj,
    cluster_repo      = var.cluster_repo,
    tenants = [for ns in var.namespaces : {
      project : ns.flux.proj
      repo : ns.flux.repo
      namespace : ns.name
      }
      if ns.flux.enabled
    ],
  })]
}

data "azuredevops_project" "this" {
  name = var.azure_devops_proj
}

# Cluster
data "azuredevops_git_repository" "cluster" {
  project_id = data.azuredevops_project.this.id
  name       = var.cluster_repo
}

data "flux_install" "this" {
  target_path = "clusters/${var.cluster_id}"
}

data "flux_sync" "this" {
  url         = "${local.git_auth_proxy_url}/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.cluster_repo}"
  branch      = var.branch
  target_path = "clusters/${var.cluster_id}"
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.this.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.this.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

resource "kubectl_manifest" "install" {
  depends_on = [kubernetes_namespace.this]
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }

  apply_only = true
  yaml_body  = each.value
}

resource "kubectl_manifest" "sync" {
  depends_on = [kubernetes_namespace.this]
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }

  apply_only = true
  yaml_body  = each.value
}

resource "azuredevops_git_repository_file" "install" {
  repository_id       = data.azuredevops_git_repository.cluster.id
  file                = data.flux_install.this.path
  content             = data.flux_install.this.content
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [
      commit_message,
    ]
  }
}

resource "azuredevops_git_repository_file" "sync" {
  repository_id       = data.azuredevops_git_repository.cluster.id
  file                = data.flux_sync.this.path
  content             = data.flux_sync.this.content
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [
      commit_message,
    ]
  }
}

resource "azuredevops_git_repository_file" "kustomize" {
  repository_id       = data.azuredevops_git_repository.cluster.id
  file                = data.flux_sync.this.kustomize_path
  content             = file("${path.module}/templates/kustomization-override.yaml")
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [
      commit_message,
    ]
  }
}

resource "azuredevops_git_repository_file" "cluster_tenants" {
  repository_id = data.azuredevops_git_repository.cluster.id
  file          = "clusters/${var.cluster_id}/tenants.yaml"
  content = templatefile("${path.module}/templates/cluster-tenants.yaml", {
    cluster_id = var.cluster_id
  })
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [
      commit_message,
    ]
  }
}

# Tenants
resource "azuredevops_git_repository_file" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  repository_id = data.azuredevops_git_repository.cluster.id
  branch        = "refs/heads/${var.branch}"
  file          = "tenants/${var.cluster_id}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/tenant.yaml", {
    repo                = "${local.git_auth_proxy_url}/${var.azure_devops_org}/${each.value.flux.proj}/_git/${each.value.flux.repo}"
    branch              = var.branch,
    name                = each.key,
    environment         = var.environment,
    include_tenant_name = each.value.flux.include_tenant_name,
    create_crds         = each.value.flux.create_crds
  })
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [
      commit_message,
    ]
  }
}
