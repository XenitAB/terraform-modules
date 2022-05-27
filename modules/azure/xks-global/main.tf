terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azuread = {
      version = "2.19.1"
      source  = "hashicorp/azuread"
    }
  }
}

locals {
  url_prefix           = var.cloud_provider == "azure" ? "aks" : "eks"
  azad_kube_proxy_url  = var.azad_kube_proxy_config.proxy_url_override == "" ? "https://${local.url_prefix}.${var.azad_kube_proxy_config.dns_zone}" : var.azad_kube_proxy_config.proxy_url_override
  azad_kube_proxy_name = "${var.azad_kube_proxy_config.cluster_name_prefix}-${var.environment}"
}

module "azad_kube_proxy" {
  source       = "../../azure-ad/azad-kube-proxy"
  proxy_url    = local.azad_kube_proxy_url
  display_name = local.azad_kube_proxy_name
  cluster_name = local.azad_kube_proxy_name
}
