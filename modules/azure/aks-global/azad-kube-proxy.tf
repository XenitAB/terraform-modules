locals {
  azad_kube_proxy_url  = var.azad_kube_proxy_config.proxy_url_override == "" ? "https://aks-${var.location_short}.${var.dns_zone[0]}" : var.azad_kube_proxy_config.proxy_url_override
  azad_kube_proxy_name = "${var.azad_kube_proxy_config.cluster_name_prefix}-${var.environment}-${var.location_short}"
}

module "azad_kube_proxy" {
  source = "../../azure-ad/azad-kube-proxy"

  proxy_url    = local.azad_kube_proxy_url
  display_name = local.azad_kube_proxy_name
  cluster_name = local.azad_kube_proxy_name
}
