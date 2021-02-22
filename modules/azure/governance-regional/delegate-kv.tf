resource "azurerm_key_vault" "delegate_kv" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  name                = join("-", compact(["kv-${var.environment}-${var.location_short}-${each.value.common_name}", var.unique_suffix]))
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "ap_owner_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_service_principal.owner_spn.id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_rg_aad_group" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_group.rg_contributor[each.key].id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_rg_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_service_principal.aad_sp[each.key].object_id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_kvreader_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_service_principal.delegate_kv_aad[each.key].object_id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_sub_aad_group_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_group.sub_owner.id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_sub_aad_group_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_group.sub_contributor.id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}
