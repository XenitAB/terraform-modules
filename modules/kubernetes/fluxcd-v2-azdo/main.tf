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
    flux = {
      source  = "fluxcd/flux"
      version = "0.0.12"
    }
    azuredevops = {
      source  = "xenitab/azuredevops"
      version = "0.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.10.0"
    }
  }
}

locals {
  repo_url = "http://git-cache-http-server/dev.azure.com/${var.azure_devops_org}/${var.azure_devops_proj}/_git/${var.bootstrap_repo}"
}

# FluxCD
data "flux_install" "main" {
  target_path = var.bootstrap_path
}

data "flux_sync" "main" {
  url         = local.repo_url
  target_path = var.bootstrap_path
  branch      = var.branch
  interval    = 1
}

# Azure DevOps
data "azuredevops_project" "this" {
  name = var.azure_devops_proj
}

resource "azuredevops_git_repository" "this" {
  project_id = data.azuredevops_project.this.id
  name       = var.bootstrap_repo
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_git_repository" "groups" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  project_id = data.azuredevops_project.this.id
  name       = each.key
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_git_repository_file" "install" {
  repository_id = azuredevops_git_repository.this.id
  file          = data.flux_install.main.path
  content       = data.flux_install.main.content
  branch        = "refs/heads/${var.branch}"
}

resource "azuredevops_git_repository_file" "sync" {
  repository_id = azuredevops_git_repository.this.id
  file          = data.flux_sync.main.path
  content       = data.flux_sync.main.content
  branch        = "refs/heads/${var.branch}"
}

resource "azuredevops_git_repository_file" "kustomize" {
  repository_id = azuredevops_git_repository.this.id
  file          = data.flux_sync.main.kustomize_path
  content       = data.flux_sync.main.kustomize_content
  branch        = "refs/heads/${var.branch}"
}

resource "azuredevops_git_repository_file" "groups" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  repository_id = azuredevops_git_repository.this.id
  file          = "${var.bootstrap_path}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/main.yaml", {
    azdo_org  = var.azure_devops_org,
    azdo_proj = var.azure_devops_proj,
    azdo_repo = each.key
  })
  branch = "refs/heads/${var.branch}"
}

# Kubernetes
resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in data.kubectl_file_documents.install.documents : sha1(v) => v }
  depends_on = [kubernetes_namespace.flux_system]

  yaml_body = each.value
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in data.kubectl_file_documents.sync.documents : sha1(v) => v }
  depends_on = [kubectl_manifest.install, kubernetes_namespace.flux_system]

  yaml_body = each.value
}

resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.name
    namespace = data.flux_sync.main.namespace
  }

  data = {
    username = var.azure_devops_org
    password = var.azure_devops_pat
  }
}

resource "kubectl_manifest" "git_cache_deplopyment" {
  yaml_body = file("${path.module}/files/deployment.yaml")
}

resource "kubectl_manifest" "git_cache_service" {
  yaml_body = file("${path.module}/files/service.yaml")
}
