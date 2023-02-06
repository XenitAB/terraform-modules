terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.25.2"
    }
    git = {
      source  = "xenitab/git"
      version = "0.0.1"
    }
  }
}

locals {
  git_auth_proxy_url = "http://git-auth-proxy.git-auth-proxy.svc.cluster.local"
}

resource "kubernetes_namespace" "git_auth_proxy" {
  metadata {
    name = "git-auth-proxy"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "helm_release" "git_auth_proxy" {
  chart       = "oci://ghcr.io/xenitab/helm-charts/git-auth-proxy"
  name        = "git-auth-proxy"
  namespace   = kubernetes_namespace.git_auth_proxy.metadata[0].name
  version     = "v0.8.1"
  max_history = 3
  values = [templatefile("${path.module}/templates/git-auth-proxy-values.yaml.tpl", {
    providers    = var.providers
    cluster_repo = var.cluster_repo,
    tenants = [for ns in var.namespaces : {
      project : ns.flux.proj
      repo : ns.flux.repo
      namespace : ns.name
      }
    ],
  })]
}

resource "flux_bootstrap_git" "this" {
  depends_on = [helm_release.git_auth_proxy]

  path = "clusters/${var.cluster_id}"
  # Remove when disabling secrets is supported. 
  secret_name            = "dummy"
  kustomization_override = <<EOF

  EOF
}

resource "git_repository_file" "cluster_tenants" {
  path = "clusters/${var.cluster_id}/tenants.yaml"
  content = templatefile("${path.module}/templates/cluster-tenants.yaml", {
    cluster_id = var.cluster_id
  })
  overwrite_on_create = true
}

resource "git_repository_file" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  path = "tenants/${var.cluster_id}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/tenant.yaml", {
    name = each.key,
    url = join("/", [
      local.git_auth_proxy_url,
      var.providers[each.value.provider].organization,
      each.value.flux.project,
      var.azure_devops != null ? "_git" : "",
      each.value.flux.repository
    ])
    create_crds = each.value.flux.create_crds
    environment = var.environment,
  })
  overwrite_on_create = true
}
