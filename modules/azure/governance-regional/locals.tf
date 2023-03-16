locals {
  resource_names = {
    azurerm_resource_group = {
      prefixes = try(var.resource_name_overrides.azurerm_resource_group.prefixes, null) != null ? var.resource_name_overrides.azurerm_resource_group.prefixes : ["rg", var.environment, var.location_short]
      suffixes = try(var.resource_name_overrides.azurerm_resource_group.suffixes, null) != null ? var.resource_name_overrides.azurerm_resource_group.suffixes : []
    }
    azurerm_key_vault = {
      prefixes = try(var.resource_name_overrides.azurerm_key_vault.prefixes, null) != null ? var.resource_name_overrides.azurerm_key_vault.prefixes : ["kv", var.environment, var.location_short]
      suffixes = try(var.resource_name_overrides.azurerm_key_vault.suffixes, null) != null ? var.resource_name_overrides.azurerm_key_vault.suffixes : [var.unique_suffix]
    }
  }
  key_vault_default_permissions = {
    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey"
    ]
    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]
    certificate_permissions = [
      "Backup",
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "Recover",
      "Restore",
      "SetIssuers",
      "Update"
    ]
  }
}
