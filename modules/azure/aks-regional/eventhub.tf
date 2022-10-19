data "azurerm_resource_group" "log" {
  name = "rg-${var.environment}-${var.location_short}-log"
}


resource "azurerm_eventhub_namespace" "this" {
  name                = var.unique_suffix == "" ? "log-${var.environment}-${var.location_short}-${var.name}" : "log-${var.environment}-${var.location_short}-${var.name}-${var.unique_suffix}"
  location            = data.azurerm_resource_group.log.location
  resource_group_name = data.azurerm_resource_group.log.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub_namespace_authorization_rule" "aks" {
  name                = "diagnostic-${var.environment}-${var.location_short}-${var.name}"
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = azurerm_eventhub_namespace.this.resource_group_name

  listen = false
  send   = true
  manage = false
}

resource "azurerm_eventhub_namespace_authorization_rule" "listen" {
  name                = "listen-${var.environment}-${var.location_short}-${var.name}"
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = azurerm_eventhub_namespace.this.resource_group_name

  listen = true
  send   = false
  manage = false
}

resource "azurerm_eventhub" "this" {
  name                = var.unique_suffix == "" ? "audit-${var.environment}-${var.location_short}-${var.name}" : "audit-${var.environment}-${var.location_short}-${var.name}-${var.unique_suffix}"
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = azurerm_eventhub_namespace.this.resource_group_name
  partition_count     = 2
  message_retention   = 1
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "eventhub_connection_string" {
  name         = "eventhub-connectionstring"
  value        = azurerm_eventhub_namespace_authorization_rule.listen.primary_connection_string
  key_vault_id = data.azurerm_key_vault.core.id
  content_type = "string"
}
