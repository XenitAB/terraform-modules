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

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azad_kube_proxy" {
  name         = "azad-kube-proxy-${var.environment}-${var.location_short}-${var.name}"
  key_vault_id = data.azurerm_key_vault.core.id
  value        = module.azad_kube_proxy.data.client_secret
  content_type = "string"
}
