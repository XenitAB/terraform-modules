data "azurecaf_name" "azurerm_resource_group_log" {
  name          = var.log_common_name
  resource_type = "azurerm_resource_group"
  prefixes      = module.names.this.azurerm_resource_group.prefixes
  suffixes      = module.names.this.azurerm_resource_group.suffixes
  use_slug      = false
}

data "azurerm_resource_group" "log" {
  name = data.azurecaf_name.azurerm_resource_group_log.result
}

# NOTE: Using `log` as the prefix for a storage account isn't what we normally do, 
#       but keeping it for backward compatibility.
#       This will by default generate: logdevwecore1234 
#                                      log{env}{location_short}{name}{unique_suffix}
data "azurecaf_name" "azurerm_storage_account_log" {
  name          = var.name
  resource_type = "azurerm_storage_account"
  prefixes      = module.names.this.azurerm_storage_account_log.prefixes
  suffixes      = module.names.this.azurerm_storage_account_log.suffixes
  use_slug      = false
}

#tfsec:ignore:azure-storage-queue-services-logging-enabled
resource "azurerm_storage_account" "log" {
  name                             = data.azurecaf_name.azurerm_storage_account_log.result
  resource_group_name              = data.azurerm_resource_group.log.name
  location                         = data.azurerm_resource_group.log.location
  account_tier                     = "Standard"
  account_replication_type         = "GRS"
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = false
  is_hns_enabled                   = true # Makes it possible to use power BI on the storage account
  cross_tenant_replication_enabled = true
}

data "azurecaf_name" "azurerm_monitor_action_group_this" {
  for_each = {
    for s in ["alerts"] :
    s => s
    if var.alerts_enabled
  }

  name          = "xenit-devops"
  resource_type = "general"
  prefixes      = module.names.this.azurerm_monitor_action_group.prefixes
  suffixes      = module.names.this.azurerm_monitor_action_group.suffixes
  use_slug      = false
}

resource "azurerm_monitor_action_group" "this" {
  for_each = {
    for s in ["alerts"] :
    s => s
    if var.alerts_enabled
  }

  name                = data.azurecaf_name.azurerm_monitor_action_group_this["alerts"].result
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
  frequency           = "PT15M"
  window_size         = "PT1H"

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
  severity = 2
}
