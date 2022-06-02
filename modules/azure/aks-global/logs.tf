resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-${var.environment}-${var.location_short}-${var.name}-${var.unique_suffix}"
  resource_group_name = data.azurerm_resource_group.log.name
  location            = data.azurerm_resource_group.log.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

#tfsec:ignore:azure-storage-queue-services-logging-enabled
resource "azurerm_storage_account" "log" {
  name                     = "log${var.environment}${var.location_short}${var.name}${var.unique_suffix}"
  resource_group_name      = data.azurerm_resource_group.log.name
  location                 = data.azurerm_resource_group.log.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  min_tls_version          = "TLS1_2"
}
