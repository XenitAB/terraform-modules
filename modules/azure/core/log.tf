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
