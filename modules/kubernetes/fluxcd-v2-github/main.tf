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
  required_version = "0.14.7"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    github = {
      source  = "hashicorp/github"
      version = "4.4.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.0.12"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.10.0"
    }
  }
}

locals {
  known_hosts = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
}

resource "kubernetes_namespace" "flux_system" {
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

# Cluster
data "github_repository" "cluster" {
  name = var.cluster_repo
}

resource "tls_private_key" "cluster" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "flux_install" "this" {
  target_path = "clusters/${var.environment}"
}

data "flux_sync" "this" {
  url         = "ssh://git@github.com/${var.github_owner}/${var.cluster_repo}.git"
  target_path = "clusters/${var.environment}"
  branch      = var.branch
  interval    = 1
}

resource "github_repository_deploy_key" "cluster" {
  title      = "flux-${var.environment}"
  repository = data.github_repository.cluster.name
  key        = tls_private_key.cluster.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "install" {
  repository          = data.github_repository.cluster.name
  branch              = var.branch
  file                = data.flux_install.this.path
  content             = data.flux_install.this.content
  overwrite_on_create = true
}

resource "github_repository_file" "sync" {
  repository          = data.github_repository.cluster.name
  branch              = var.branch
  file                = data.flux_sync.this.path
  content             = data.flux_sync.this.content
  overwrite_on_create = true
}

resource "github_repository_file" "kustomize" {
  repository          = data.github_repository.cluster.name
  branch              = var.branch
  file                = data.flux_sync.this.kustomize_path
  content             = data.flux_sync.this.kustomize_content
  overwrite_on_create = true
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

resource "kubernetes_secret" "cluster" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.this.name
    namespace = data.flux_sync.this.namespace
  }

  data = {
    identity       = tls_private_key.cluster.private_key_pem
    "identity.pub" = tls_private_key.cluster.public_key_pem
    known_hosts    = local.known_hosts
  }
}

resource "github_repository_file" "cluster_tenants" {
  repository = data.github_repository.cluster.name
  branch     = var.branch
  file       = "clusters/${var.environment}/tenants.yaml"
  content = templatefile("${path.module}/templates/cluster-tenants.yaml", {
    environment = var.environment
  })
  overwrite_on_create = true
}

# Tenants
data "github_repository" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  name = each.value.flux.repo
}

resource "tls_private_key" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "github_repository_deploy_key" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  title      = "flux-${var.environment}"
  repository = data.github_repository.tenant[each.key].name
  key        = tls_private_key.tenant[each.key].public_key_openssh
  read_only  = true
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
    identity       = tls_private_key.tenant[each.key].private_key_pem
    "identity.pub" = tls_private_key.tenant[each.key].public_key_pem
    known_hosts    = local.known_hosts
  }
}

resource "github_repository_file" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  repository = data.github_repository.cluster.name
  branch     = var.branch
  file       = "tenants/${var.environment}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/tenant.yaml", {
    repo        = "ssh://git@github.com/${data.github_repository.tenant[each.key].full_name}.git",
    branch      = var.branch,
    name        = each.key,
    environment = var.environment,
  })
  overwrite_on_create = true
}
