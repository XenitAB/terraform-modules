/**
 * # Azure AD Kubernetes API Proxy
 * Adds [`azad-kube-proxy`](https://github.com/XenitAB/azad-kube-proxy) to a Kubernetes clusters.
 *
 * # Terraform example (aks-core)
 *
 * module "aks_core" {
 *   source = "github.com/xenitab/terraform-modules//modules/kubernetes/aks-core?ref=[ref]"
 *
 *   [...]
 *
 *   azad_kube_proxy_enabled = true
 *   azad_kube_proxy_config = {
 *     fqdn                  = "aks.${var.dns_zone}"
 *     azure_ad_group_prefix = var.aks_group_name_prefix
 *     allowed_ips           = var.aks_authorized_ips
 *     azure_ad_app          = module.aks_global.azad_kube_proxy.azure_ad_app
 *   }
 * }
 * ```
 *
*/

terraform {
  required_version = ">= 1.2.6"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

locals {
  aad_config = {
    CLIENT_ID     = var.azure_ad_app.client_id
    CLIENT_SECRET = var.azure_ad_app.client_secret
    TENANT_ID     = var.azure_ad_app.tenant_id
  }
  secret_data = local.aad_config
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    fqdn                  = var.fqdn,
    allowed_ips_csv       = join(",", var.allowed_ips),
    azure_ad_group_prefix = var.azure_ad_group_prefix
  })
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "azad-kube-proxy"
      "xkf.xenit.io/kind" = "platform"
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
  depends_on  = [kubernetes_secret.this]
  repository  = "https://xenitab.github.io/azad-kube-proxy"
  chart       = "azad-kube-proxy"
  name        = "azad-kube-proxy"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "v0.0.34"
  max_history = 3
  values      = [local.values]
}
