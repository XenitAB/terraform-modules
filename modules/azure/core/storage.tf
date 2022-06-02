resource "azurerm_storage_account" "this" {
  for_each = {
    for s in ["storage_account"] :
    s => s
    if var.enable_storage_account
  }

  name                     = "sa${var.environment}${var.location_short}${var.name}${var.unique_suffix}"
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"
}
