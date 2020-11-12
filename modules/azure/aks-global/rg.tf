# Add datasource for resource group
data "azurerm_resource_group" "rg" {
  name = "rg-${var.environment}-${var.location_short}-${var.name}"
}
