#tfsec:ignore:azure-storage-queue-services-logging-enabled
resource "azurerm_storage_account" "velero" {
  name                            = var.azure_config.storage_account_name == "" ? "strg${var.environment}velero${var.unique_suffix}" : var.azure_config.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "velero" {
  storage_account_name  = azurerm_storage_account.velero.name
  name                  = var.azure_config.storage_account_container == "" ? "backup" : var.azure_config.storage_account_container
  container_access_type = "private"
}