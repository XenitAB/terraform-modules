resource "azurerm_key_vault_access_policy" "ap_owner_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.rbac_authorization_enabled_kv == false
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
    if rg.delegate_key_vault == true && rg.rbac_authorization_enabled_kv == false
  }

  key_vault_id            = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = var.azuread_groups.rg_contributor[each.key].id
  key_permissions         = local.key_vault_default_permissions.key_permissions
  secret_permissions      = local.key_vault_default_permissions.secret_permissions
  certificate_permissions = local.key_vault_default_permissions.certificate_permissions
}

resource "azurerm_key_vault_access_policy" "ap_rg_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.delegate_service_principal == true && rg.rbac_authorization_enabled_kv == false
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = var.azuread_apps.rg_contributor[each.key].service_principal_object_id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_kvreader_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.rbac_authorization_enabled_kv == false
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = var.azuread_apps.delegate_kv[each.key].service_principal_object_id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_sub_aad_group_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.rbac_authorization_enabled_kv == false
  }

  key_vault_id            = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = var.azuread_groups.sub_owner.id
  key_permissions         = local.key_vault_default_permissions.key_permissions
  secret_permissions      = local.key_vault_default_permissions.secret_permissions
  certificate_permissions = local.key_vault_default_permissions.certificate_permissions
}

resource "azurerm_key_vault_access_policy" "ap_sub_aad_group_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.rbac_authorization_enabled_kv == false
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = var.azuread_groups.sub_contributor.id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}
