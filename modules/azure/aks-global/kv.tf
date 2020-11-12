data "azurerm_key_vault" "core" {
  name                = "kv-${var.environment}-${var.location_short}-${var.coreCommonName}"
  resource_group_name = "rg-${var.environment}-${var.location_short}-${var.coreCommonName}"
}
