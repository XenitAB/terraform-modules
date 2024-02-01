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
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/azad-kube-proxy.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "node_ttl" {
  path = "platform/${var.cluster_id}/azad-kube-proxy/azad-kube-proxy.yaml"
  content = templatefile("${path.module}/templates/azad-kube-proxy.yaml.tpl", {
    fqdn                  = var.fqdn,
    allowed_ips_csv       = join(",", var.allowed_ips),
    azure_ad_group_prefix = var.azure_ad_group_prefix
    client_id             = base64encode(var.azure_ad_app.client_id)
    client_secret         = base64encode(var.azure_ad_app.client_secret)
    tenant_id             = base64encode(var.azure_ad_app.tenant_id)
  })
}
