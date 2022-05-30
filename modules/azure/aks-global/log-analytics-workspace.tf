resource "azurerm_log_analytics_workspace" "aks" {
  name                = "aks-${var.environment}-${var.location_short}-${var.name}-${var.unique_suffix}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "logs" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.aks.location
  resource_group_name   = data.azurerm_resource_group.this.name
  workspace_resource_id = azurerm_log_analytics_workspace.aks.id
  workspace_name        = azurerm_log_analytics_workspace.aks.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
