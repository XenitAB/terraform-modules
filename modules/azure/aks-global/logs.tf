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
  is_hns_enabled           = true
}


resource "azurerm_eventhub_namespace" "this" {
  name                = "log-${var.environment}-${var.location_short}-${var.name}-${var.unique_suffix}"
  location            = data.azurerm_resource_group.log.location
  resource_group_name = data.azurerm_resource_group.log.name
  sku                 = "Basic"
  capacity            = 1
}

resource "azurerm_eventhub_namespace_authorization_rule" "this" {
  name                = "diagnostic-${var.environment}-${var.location_short}-${var.name}"
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = azurerm_eventhub_namespace.resource_group_name

  listen = false
  send   = true
  manage = false
}

resource "azurerm_eventhub" "this" {
  name                = "audit-${var.environment}-${var.location_short}-${var.name}-${var.unique_suffix}"
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = azurerm_eventhub_namespace.resource_group_name
  partition_count     = 2
  message_retention   = 1
}
