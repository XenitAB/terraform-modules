data "azurecaf_name" "azurerm_storage_account_this" {
  for_each = {
    for s in ["storage_account"] :
    s => s
    if var.enable_storage_account
  }

  name          = var.name
  resource_type = "azurerm_storage_account"
  prefixes      = module.names.this.azurerm_storage_account.prefixes
  suffixes      = module.names.this.azurerm_storage_account.suffixes
  use_slug      = false
}

resource "azurerm_storage_account" "this" {
  for_each = {
    for s in ["storage_account"] : # NOTE: We're not using underscore for this usually, should be "storage-account".
    s => s
    if var.enable_storage_account
  }

  name                            = data.azurecaf_name.azurerm_storage_account_this["storage_account"].result
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = data.azurerm_resource_group.this.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
}
