data "azurerm_key_vault" "core" {
  name                = var.keyvault_name_override == "" ? join("-", compact(["kv-${var.environment}-${var.location_short}-${var.core_name}", var.unique_suffix])) : var.keyvault_name_override
  resource_group_name = "rg-${var.environment}-${var.location_short}-${var.core_name}"
}
