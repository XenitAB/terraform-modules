data "azurerm_resource_group" "log" {
  name = "rg-${var.environment}-${var.location_short}-log"
}

#tfsec:ignore:azure-storage-queue-services-logging-enabled
resource "azurerm_storage_account" "log" {
  name                     = "log${var.environment}${var.location_short}${var.name}${var.unique_suffix}"
  resource_group_name      = data.azurerm_resource_group.log.name
  location                 = data.azurerm_resource_group.log.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
  # is_hsn_enabled makes it possible to use power BI on the storage account
  is_hns_enabled = true
}

resource "azurerm_monitor_action_group" "this" {
  for_each = {
    for s in ["alerts"] :
    s => s
    if var.alerts_enabled
  }
  name                = "xenit-devops-${var.environment}-${var.location_short}-${var.name}-${var.unique_suffix}"
  resource_group_name = data.azurerm_resource_group.log.name
  short_name          = "xenit-devops"

  email_receiver {
    name                    = "xenit-devops"
    email_address           = var.notification_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "log" {
  for_each = {
    for s in ["alerts"] :
    s => s
    if var.alerts_enabled
  }
  name                = "audit log${var.environment}${var.location_short}${var.name}${var.unique_suffix} storage account missing data"
  resource_group_name = data.azurerm_resource_group.log.name
  scopes              = [azurerm_storage_account.log.id]
  description         = "No data being written to the storage account, check the AKS audit logs"
  frequency           = "PT5M"

  criteria {
    aggregation            = "Average"
    metric_name            = "Ingress"
    metric_namespace       = "Microsoft.Storage/storageAccounts"
    operator               = "LessThan"
    skip_metric_validation = false
    threshold              = 51200
  }

  action {
    action_group_id = azurerm_monitor_action_group.this["alerts"].id
  }
  severity = 1
}
