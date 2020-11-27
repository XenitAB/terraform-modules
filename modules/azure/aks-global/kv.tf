data "azurerm_key_vault" "core" {
  name                = join("-", compact(["kv-${var.environment}-${var.location_short}-${var.core_name}", var.unique_suffix]))
  resource_group_name = "rg-${var.environment}-${var.location_short}-${var.core_name}"
}
