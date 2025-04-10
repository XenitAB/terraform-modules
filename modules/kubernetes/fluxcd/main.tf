terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.4.0"
    }
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

locals {
  git_auth_proxy_url = "http://git-auth-proxy.git-auth-proxy.svc.cluster.local"
  git_path_separator = var.git_provider.azure_devops != null ? "_git" : ""
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
  depends_on = [
    kubernetes_namespace.git_auth_proxy,
    kubernetes_namespace.flux_system
  ]

  chart       = "oci://ghcr.io/xenitab/helm-charts/git-auth-proxy"
  name        = "git-auth-proxy"
  namespace   = kubernetes_namespace.git_auth_proxy.metadata[0].name
  version     = "v0.8.1"
  max_history = 3
  values = [templatefile("${path.module}/templates/git-auth-proxy-values.yaml.tpl", {
    git_provider = var.git_provider
    private_key  = var.git_provider.type == "github" ? base64encode(var.git_provider.github.private_key) : null
    bootstrap    = var.bootstrap
    tenants      = [for tenant in var.namespaces : tenant if tenant.fluxcd != null]
  })]
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

resource "flux_bootstrap_git" "this" {
  depends_on = [helm_release.git_auth_proxy]

  #path                    = "clusters/${var.cluster_id}"
  path                    = "tenants/${var.cluster_id}"
  disable_secret_creation = var.bootstrap.disable_secret_creation
  components              = toset(["source-controller", "kustomize-controller", "helm-controller", "notification-controller"])
  kustomization_override = templatefile("${path.module}/templates/kustomization-override.yaml.tpl", {
    url = join("/", compact([local.git_auth_proxy_url, var.git_provider.organization, var.bootstrap.project, local.git_path_separator, var.bootstrap.repository]))
  })
}

resource "git_repository_file" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.fluxcd != null
  }

  path    = "tenants/${var.cluster_id}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/tenant.yaml", {
    create_crds         = each.value.fluxcd.create_crds,
    environment         = var.environment,
    name                = each.key,
    include_tenant_name = each.value.fluxcd.include_tenant_name,
    provider_type       = var.git_provider.type
    url = join("/", compact([
      local.git_auth_proxy_url,
      var.git_provider.organization,
      each.value.fluxcd.project,
      local.git_path_separator,
      each.value.fluxcd.repository
    ]))
  })

  lifecycle {
    ignore_changes = [
      author_name,
      message,
      content,
    ]
  }
}
