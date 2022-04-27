terraform {
  required_version = ">= 1.1.7"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.11.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    azuredevops = {
      source  = "xenitab/azuredevops"
      version = "0.5.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.21.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.1"
    }
  }
}

locals {
  git_auth_proxy_url = "http://git-auth-proxy.flux-system.svc.cluster.local"
}

resource "kubernetes_namespace" "this" {
  lifecycle {
    prevent_destroy = true
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
  repository  = "https://xenitab.github.io/git-auth-proxy/"
  chart       = "git-auth-proxy"
  name        = "git-auth-proxy"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "v0.5.2"
  max_history = 3
  values = [templatefile("${path.module}/templates/git-auth-proxy-values.yaml.tpl", {
    azure_devops_pat  = var.azure_devops_pat,
    azure_devops_org  = var.azure_devops_org,
    azure_devops_proj = var.azure_devops_proj,
    cluster_repo      = var.cluster_repo,
    github_org        = var.github_org
    app_id            = tonumber(var.github_app_id)
    installation_id   = tonumber(var.github_installation_id)
    private_key       = base64encode(var.github_private_key)
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

data "github_repository" "cluster" {
  full_name = "${var.github_org}/${var.cluster_repo}"
}

data "flux_install" "this" {
  target_path = "clusters/${var.cluster_id}"
}

data "flux_sync" "this" {
  url                = "${local.git_auth_proxy_url}/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.cluster_repo}"
  branch             = var.branch
  target_path        = "clusters/${var.cluster_id}"
  git_implementation = "libgit2"
}

data "flux_sync" "this" {
  url         = "${local.git_auth_proxy_url}/${var.github_org}/${var.cluster_repo}"
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
  lifecycle {
    prevent_destroy = true
  }
  for_each = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }

  yaml_body = each.value
}

resource "kubectl_manifest" "sync" {
  depends_on = [kubernetes_namespace.this]
  lifecycle {
    prevent_destroy = true
  }
  for_each = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }

  yaml_body = each.value
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
  content             = file("${path.module}/templates/kustomization-override.yaml")
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true
}

resource "azuredevops_git_repository_file" "cluster_tenants" {
  repository_id = data.azuredevops_git_repository.cluster.id
  file          = "clusters/${var.cluster_id}/tenants.yaml"
  content = templatefile("${path.module}/templates/cluster-tenants.yaml", {
    cluster_id = var.cluster_id
  })
  branch              = "refs/heads/${var.branch}"
  overwrite_on_create = true
}

resource "github_repository_file" "install" {
  repository          = data.github_repository.cluster.name
  file                = data.flux_install.this.path
  content             = data.flux_install.this.content
  branch              = var.branch
  overwrite_on_create = true
}

resource "github_repository_file" "sync" {
  repository          = data.github_repository.cluster.name
  file                = data.flux_sync.this.path
  content             = data.flux_sync.this.content
  branch              = var.branch
  overwrite_on_create = true
}

resource "github_repository_file" "kustomize" {
  repository          = data.github_repository.cluster.name
  file                = data.flux_sync.this.kustomize_path
  content             = file("${path.module}/templates/kustomization-override.yaml")
  branch              = var.branch
  overwrite_on_create = true
}

resource "github_repository_file" "cluster_tenants" {
  repository = data.github_repository.cluster.name
  file       = "clusters/${var.cluster_id}/tenants.yaml"
  content = templatefile("${path.module}/templates/cluster-tenants.yaml", {
    cluster_id = var.cluster_id
  })
  branch              = var.branch
  overwrite_on_create = true
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
    repo        = "${local.git_auth_proxy_url}/${var.azure_devops_org}/${each.value.flux.proj}/_git/${each.value.flux.repo}"
    branch      = var.branch,
    name        = each.key,
    environment = var.environment,
    create_crds = each.value.flux.create_crds
  })
  overwrite_on_create = true
}

resource "github_repository_file" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }
  repository = data.github_repository.cluster.name
  branch     = var.branch
  file       = "tenants/${var.cluster_id}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/tenant.yaml", {
    repo        = "${local.git_auth_proxy_url}/${var.github_org}/${each.value.flux.repo}.git"
    branch      = var.branch,
    name        = each.key,
    environment = var.environment,
    create_crds = false,
  })
  overwrite_on_create = true
}