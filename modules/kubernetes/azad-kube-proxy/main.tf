/**
  * # Azure AD Kubernetes API Proxy
  *
  * Adds [`azad-kube-proxy`](https://github.com/XenitAB/azad-kube-proxy) to a Kubernetes clusters.
  * 
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}

locals {
  k8dash_config = var.dashboard == "k8dash" ? { K8DASH_CLIENT_ID = var.k8dash_config.client_id, K8DASH_CLIENT_SECRET = var.k8dash_config.client_secret, K8DASH_SCOPE = var.k8dash_config.scope } : {}
  aad_config = {
    CLIENT_ID     = var.azure_ad_app.client_id
    CLIENT_SECRET = var.azure_ad_app.client_secret
    TENANT_ID     = var.azure_ad_app.tenant_id
  }
  secret_data = merge(local.aad_config, local.k8dash_config)
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    dashboard       = var.dashboard
    fqdn            = var.fqdn,
    allowed_ips_csv = join(",", var.allowed_ips),
  })
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = "azad-kube-proxy"
    }
    name = "azad-kube-proxy"
  }
}

resource "kubernetes_secret" "this" {
  metadata {
    name      = "azad-kube-proxy"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  data = local.secret_data
}

resource "helm_release" "azad_kube_proxy" {
  depends_on = [kubernetes_secret.this]
  repository = "https://xenitab.github.io/azad-kube-proxy"
  chart      = "azad-kube-proxy"
  name       = "azad-kube-proxy"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v0.0.13"
  values     = [local.values]
}
