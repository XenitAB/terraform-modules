/**
 * # Flux V2
 *
 * Installs and configures [flux2](https://github.com/fluxcd/flux2) with GitHub.
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
  required_version = "0.13.5"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    github = {
      source  = "hashicorp/github"
      version = "4.0.1"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.0.5"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.9.1"
    }
  }
}

locals {
  known_hosts = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
}

# SSH
resource "tls_private_key" "bootstrap" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# FluxCD
data "flux_install" "this" {
  target_path = var.bootstrap_path
}

data "flux_sync" "this" {
  url         = "ssh://git@github.com/${var.github_owner}/${var.bootstrap_repo}.git"
  target_path = var.bootstrap_path
  branch      = var.branch
  interval    = 60000000000
}

# GitHub
resource "github_repository" "bootstrap" {
  name           = var.bootstrap_repo
  visibility     = var.repository_visibility
  default_branch = var.branch
  auto_init      = true
}

resource "github_repository_deploy_key" "bootstrap" {
  title      = "staging-cluster"
  repository = github_repository.bootstrap.name
  key        = tls_private_key.bootstrap.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "install" {
  repository = github_repository.bootstrap.name
  file       = data.flux_install.this.path
  content    = data.flux_install.this.content
  branch     = var.branch
}

resource "github_repository_file" "sync" {
  repository = github_repository.bootstrap.name
  file       = data.flux_sync.this.path
  content    = data.flux_sync.this.content
  branch     = var.branch
}

resource "github_repository_file" "kustomize" {
  repository = github_repository.bootstrap.name
  file       = data.flux_sync.this.kustomize_path
  content    = data.flux_sync.this.kustomize_content
  branch     = var.branch
}

resource "github_repository" "group" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  name           = each.key
  visibility     = var.repository_visibility
  default_branch = var.branch
  auto_init      = true
}

resource "github_repository_deploy_key" "group" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  title      = "staging-cluster"
  repository = github_repository.bootstrap.name
  key        = tls_private_key.bootstrap.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "group" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  repository = github_repository.bootstrap.name
  file       = "${var.bootstrap_path}/${each.key}.yaml"
  content    = templatefile("${path.module}/templates/main.yaml", { github_owner = var.github_owner, name = each.key })
  branch     = var.branch
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
  content = data.flux_install.this.content
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in data.kubectl_file_documents.install.documents : sha1(v) => v }
  depends_on = [kubernetes_namespace.flux_system]

  yaml_body = each.value
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.this.content
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in data.kubectl_file_documents.sync.documents : sha1(v) => v }
  depends_on = [kubectl_manifest.install, kubernetes_namespace.flux_system]

  yaml_body = each.value
}

resource "kubernetes_secret" "bootstrap" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.this.name
    namespace = data.flux_sync.this.namespace
  }

  data = {
    identity       = tls_private_key.bootstrap.private_key_pem
    "identity.pub" = tls_private_key.bootstrap.public_key_pem
    known_hosts    = local.known_hosts
  }
}
