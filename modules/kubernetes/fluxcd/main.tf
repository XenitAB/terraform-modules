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
      version = "0.25.3"
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
  chart       = "oci://ghcr.io/xenitab/helm-charts/git-auth-proxy"
  name        = "git-auth-proxy"
  namespace   = kubernetes_namespace.git_auth_proxy.metadata[0].name
  version     = "v0.8.1"
  max_history = 3
  values = [templatefile("${path.module}/templates/git-auth-proxy-values.yaml.tpl", {
    git_provider = var.git_provider
    bootstrap    = var.bootstrap
    tenants      = var.namespaces
  })]
}

resource "flux_bootstrap_git" "this" {
  path = "clusters/${var.cluster_id}"
  # Remove when disabling secrets is supported. 
  secret_name            = "dummy"
  kustomization_override = <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- gotk-components.yaml
- gotk-sync.yaml
patchesJson6902:
- target:
    group: source.toolkit.fluxcd.io
    version: v1beta2
    kind: GitRepository
    name: flux-system
  patch: |-
    - op: replace
      path: /spec/url
      value: ${join("/", [local.git_auth_proxy_url, var.git_provider.organization, var.bootstrap.project, local.git_path_separator, var.bootstrap.repository])}
    - op: replace
      path: /spec/secretRef/name
      value: flux-system
  EOF
}

resource "git_repository_file" "cluster_tenants" {
  override_on_create = true
  path               = "clusters/${var.cluster_id}/tenants.yaml"
  content = templatefile("${path.module}/templates/cluster-tenants.yaml", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  override_on_create = true
  path               = "tenants/${var.cluster_id}/${each.key}.yaml"
  content = templatefile("${path.module}/templates/tenant.yaml", {
    name = each.key,
    url = join("/", [
      local.git_auth_proxy_url,
      var.git_provider.organization,
      each.value.flux.project,
      local.git_path_separator,
      each.value.flux.repository
    ])
    include_tenant_name = each.value.include_tenant_name
    create_crds         = each.value.flux.create_crds
    environment         = var.environment,
  })
}
