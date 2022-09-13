data "azurerm_resource_group" "log" {
  name = "rg-${var.environment}-${var.location_short}-log"
}


resource "azurerm_eventhub_namespace" "this" {
  name                = "log-${var.environment}-${var.location_short}-${var.name}-${var.unique_suffix}"
  location            = data.azurerm_resource_group.log.location
  resource_group_name = data.azurerm_resource_group.log.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub_namespace_authorization_rule" "this" {
  name                = "diagnostic-${var.environment}-${var.location_short}-${var.name}"
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = azurerm_eventhub_namespace.this.resource_group_name

  listen = false
  send   = true
  manage = false
}

resource "azurerm_eventhub" "this" {
  name                = "audit-${var.environment}-${var.location_short}-${var.name}-${var.unique_suffix}"
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = azurerm_eventhub_namespace.this.resource_group_name
  partition_count     = 2
  message_retention   = 1
}
