data "azurerm_subnet" "subnet" {
  name                 = "sn-${var.environmentShort}-${var.locationShort}-${var.coreCommonName}-${var.commonName}"
  virtual_network_name = "vnet-${var.environmentShort}-${var.locationShort}-${var.coreCommonName}"
  resource_group_name  = "rg-${var.environmentShort}-${var.locationShort}-${var.coreCommonName}"
}
