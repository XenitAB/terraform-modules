
resource "azurerm_user_assigned_identity" "azure_metrics" {
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  name                = "uai-${var.environment}-${var.location_short}-${var.name}-azure-metrics"
}
