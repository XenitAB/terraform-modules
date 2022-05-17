resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.environment}-${var.location_short}-${var.name}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
