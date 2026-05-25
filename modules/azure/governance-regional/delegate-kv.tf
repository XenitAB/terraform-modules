data "azurecaf_name" "azurerm_key_vault_delegate_kv" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  name          = each.value.common_name
  resource_type = "azurerm_key_vault"
  prefixes      = module.names.this.azurerm_key_vault.prefixes
  suffixes      = each.value.disable_unique_suffix ? null : module.names.this.azurerm_key_vault.suffixes
  use_slug      = false
}

#tfsec:ignore:AZU020 tfsec:ignore:AZU021
resource "azurerm_key_vault" "delegate_kv" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  name = data.azurecaf_name.azurerm_key_vault_delegate_kv[each.key].result

  location                    = azurerm_resource_group.rg[each.key].location
  resource_group_name         = azurerm_resource_group.rg[each.key].name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = each.value.key_vault_purge_protection_enabled
  enable_rbac_authorization   = each.value.key_vault_enable_rbac_authorization
  enabled_for_disk_encryption = true
}

# Access-policy mode (default): used when key_vault_enable_rbac_authorization == false.
# Each access policy is mirrored 1:1 by an RBAC role assignment further below; only one of
# the two modes is active per delegated Key Vault.
resource "azurerm_key_vault_access_policy" "ap_owner_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.key_vault_enable_rbac_authorization == false
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
    if rg.delegate_key_vault == true && rg.key_vault_enable_rbac_authorization == false
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
    if rg.delegate_key_vault == true && rg.delegate_service_principal == true && rg.key_vault_enable_rbac_authorization == false
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
    if rg.delegate_key_vault == true && rg.key_vault_enable_rbac_authorization == false
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
    if rg.delegate_key_vault == true && rg.key_vault_enable_rbac_authorization == false
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
    if rg.delegate_key_vault == true && rg.key_vault_enable_rbac_authorization == false
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = var.azuread_groups.sub_contributor.id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

# RBAC mode: used when key_vault_enable_rbac_authorization == true. These role assignments
# mirror the access-policy resources above 1:1. "Key Vault Administrator" is the closest
# built-in equivalent to the full key/secret/certificate permission set granted by the
# access policies.
resource "azurerm_role_assignment" "rbac_owner_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.key_vault_enable_rbac_authorization == true
  }

  scope                = azurerm_key_vault.delegate_kv[each.key].id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_service_principal.owner_spn.id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "rbac_rg_aad_group" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.key_vault_enable_rbac_authorization == true
  }

  scope                = azurerm_key_vault.delegate_kv[each.key].id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.azuread_groups.rg_contributor[each.key].id
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "rbac_rg_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.delegate_service_principal == true && rg.key_vault_enable_rbac_authorization == true
  }

  scope                = azurerm_key_vault.delegate_kv[each.key].id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.azuread_apps.rg_contributor[each.key].service_principal_object_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "rbac_kvreader_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.key_vault_enable_rbac_authorization == true
  }

  scope                = azurerm_key_vault.delegate_kv[each.key].id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.azuread_apps.delegate_kv[each.key].service_principal_object_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "rbac_sub_aad_group_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.key_vault_enable_rbac_authorization == true
  }

  scope                = azurerm_key_vault.delegate_kv[each.key].id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.azuread_groups.sub_owner.id
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "rbac_sub_aad_group_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true && rg.key_vault_enable_rbac_authorization == true
  }

  scope                = azurerm_key_vault.delegate_kv[each.key].id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.azuread_groups.sub_contributor.id
  principal_type       = "Group"
}
