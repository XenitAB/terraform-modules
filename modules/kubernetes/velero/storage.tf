#tfsec:ignore:azure-storage-queue-services-logging-enabled
resource "azurerm_storage_account" "velero" {
  name                            = "strg${var.cluster_id}velero${var.unique_suffix}"
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
  name                  = "backup"
  container_access_type = "private"
}