data "azurerm_key_vault" "core" {
  name                = "kv-${var.environment}-${var.location_short}-${var.core_name}-${var.unique_suffix}"
  resource_group_name = "rg-${var.environment}-${var.location_short}-${var.core_name}"
}

data "azurerm_key_vault_secret" "azdo_pat_admin" {
  key_vault_id = data.azurerm_key_vault.core.id
  name         = "azure-devops-pat-admin"
}

data "azurerm_key_vault_secret" "azdo_pat" {
  key_vault_id = data.azurerm_key_vault.core.id
  name         = "azure-devops-pat"
}

data "azurerm_key_vault" "rg" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  name                = "kv-${var.environment}-${var.location_short}-${each.key}-${var.unique_suffix}"
  resource_group_name = "rg-${var.environment}-${var.location_short}-${each.key}"
}

