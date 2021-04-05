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
  required_version = "0.14.7"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.3"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.1.1"
    }
    azuredevops = {
      source  = "xenitab/azuredevops"
      version = "0.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

data "azuredevops_project" "this" {
  name = var.azure_devops_proj
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = "flux-system"
    labels = {
      name = "flux-system"
    }
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

# Azdo Proxy
locals {
  azdo_proxy_values = templatefile("${path.module}/templates/azdo-proxy-values.yaml.tpl", {
    azure_devops_pat  = var.azure_devops_pat,
    azure_devops_org  = var.azure_devops_org,
    azure_devops_proj = var.azure_devops_proj,
    cluster_repo      = var.cluster_repo,
    cluster_token     = random_password.cluster.result,
    tenants = [for ns in var.namespaces : {
      project : ns.flux.proj
      repo : ns.flux.repo
      token : random_password.tenant[ns.name].result,
      }
      if ns.flux.enabled
    ]
  })
  azdo_proxy_url = "http://azdo-proxy.flux-system.svc.cluster.local"
}

resource "helm_release" "azdo_proxy" {
  repository = "https://xenitab.github.io/azdo-proxy/"
  chart      = "azdo-proxy"
  name       = "azdo-proxy"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "0.3.6"
  values     = [local.azdo_proxy_values]
}

# Cluster
data "azuredevops_git_repository" "cluster" {
  project_id = data.azuredevops_project.this.id
  name       = var.cluster_repo
}

resource "random_password" "cluster" {
  length  = 32
  special = false
}

data "flux_install" "this" {
  target_path = "clusters/${var.environment}"
  version     = "v0.10.0"
}

data "flux_sync" "this" {
  url                = "${local.azdo_proxy_url}/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.cluster_repo}"
  branch             = var.branch
  target_path        = "clusters/${var.environment}"
  git_implementation = "libgit2"
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
  yaml_body  = each.value
}

resource "kubectl_manifest" "sync" {
  depends_on = [kubernetes_namespace.this]
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  yaml_body  = each.value
}

resource "kubernetes_secret" "cluster" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.this.name
    namespace = data.flux_sync.this.namespace
  }

  data = {
    username = "git"
    password = random_password.cluster.result
  }
}

resource "azuredevops_git_repository_file" "install" {
  repository_id       = data.azuredevops_git_repository.cluster.id
  file                = data.flux_install.this.path
  content             = data.flux_install.this.content
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true
}

resource "azuredevops_git_repository_file" "sync" {
  repository_id       = data.azuredevops_git_repository.cluster.id
  file                = data.flux_sync.this.path
  content             = data.flux_sync.this.content
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true
}

resource "azuredevops_git_repository_file" "kustomize" {
  repository_id       = data.azuredevops_git_repository.cluster.id
  file                = data.flux_sync.this.kustomize_path
  content             = data.flux_sync.this.kustomize_content
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true
}

resource "azuredevops_git_repository_file" "cluster_tenants" {
  for_each = {
    for env in distinct(var.namespaces.flux.environment) :
    env => env
  }
  repository_id = data.azuredevops_git_repository.cluster.id
  file          = "clusters/${var.environment}/tenants.yaml"
  content = templatefile("${path.module}/templates/cluster-tenants.yaml", {
    environment = each.value
  })
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true
}

# Tenants
resource "random_password" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  length  = 32
  special = false
}

resource "kubernetes_secret" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = "flux"
    namespace = each.key
  }

  data = {
    username = "git"
    password = random_password.tenant[each.key].result
    token    = random_password.tenant[each.key].result
  }
}

resource "azuredevops_git_repository_file" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  repository_id = data.azuredevops_git_repository.cluster.id
  branch        = "refs/heads/${var.branch}"
  file          = "tenants/${each.value.flux.environment}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/tenant.yaml", {
    repo        = "${local.azdo_proxy_url}/${var.azure_devops_org}/${each.value.flux.proj}/_git/${each.value.flux.repo}"
    branch      = var.branch,
    name        = each.key,
    environment = each.value.flux.environment,
    create_crds = each.value.flux.create_crds
  })
  overwrite_on_create = true
}

