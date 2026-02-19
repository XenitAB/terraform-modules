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
  enabled_for_disk_encryption = true
  rbac_authorization_enabled  = true
}

resource "azurerm_role_assignment" "ra_owner_spn" {
  for_each = {
    for pair in setproduct(
      [
        for rg in var.resource_group_configs : rg.common_name
        if rg.delegate_key_vault == true
      ],
      local.key_vault_rbac_roles.key_secret
      ) : "${pair[0]}-${pair[1]}" => {
      rg_name = pair[0]
      role    = pair[1]
    }
  }

  scope                = azurerm_key_vault.delegate_kv[each.value.rg_name].id
  role_definition_name = each.value.role
  principal_id         = data.azuread_service_principal.owner_spn.id
}

resource "azurerm_role_assignment" "ra_rg_aad_group" {
  for_each = {
    for pair in setproduct(
      [
        for rg in var.resource_group_configs : rg.common_name
        if rg.delegate_key_vault == true
      ],
      local.key_vault_rbac_roles.key_secret_cert
      ) : "${pair[0]}-${pair[1]}" => {
      rg_name = pair[0]
      role    = pair[1]
    }
  }

  scope                = azurerm_key_vault.delegate_kv[each.value.rg_name].id
  role_definition_name = each.value.role
  principal_id         = var.azuread_groups.rg_contributor[each.value.rg_name].id
}

resource "azurerm_role_assignment" "ra_rg_sp" {
  for_each = {
    for pair in setproduct(
      [
        for rg in var.resource_group_configs : rg.common_name
        if rg.delegate_key_vault == true && rg.delegate_service_principal == true
      ],
      local.key_vault_rbac_roles.key_secret
      ) : "${pair[0]}-${pair[1]}" => {
      rg_name = pair[0]
      role    = pair[1]
    }
  }

  scope                = azurerm_key_vault.delegate_kv[each.value.rg_name].id
  role_definition_name = each.value.role
  principal_id         = var.azuread_apps.rg_contributor[each.value.rg_name].service_principal_object_id
}

resource "azurerm_role_assignment" "ra_kvreader_sp" {
  for_each = {
    for pair in setproduct(
      [
        for rg in var.resource_group_configs : rg.common_name
        if rg.delegate_key_vault == true
      ],
      local.key_vault_rbac_roles.key_secret
      ) : "${pair[0]}-${pair[1]}" => {
      rg_name = pair[0]
      role    = pair[1]
    }
  }

  scope                = azurerm_key_vault.delegate_kv[each.value.rg_name].id
  role_definition_name = each.value.role
  principal_id         = var.azuread_apps.delegate_kv[each.value.rg_name].service_principal_object_id
}

resource "azurerm_role_assignment" "ra_sub_aad_group_owner" {
  for_each = {
    for pair in setproduct(
      [
        for rg in var.resource_group_configs : rg.common_name
        if rg.delegate_key_vault == true
      ],
      local.key_vault_rbac_roles.key_secret_cert
      ) : "${pair[0]}-${pair[1]}" => {
      rg_name = pair[0]
      role    = pair[1]
    }
  }

  scope                = azurerm_key_vault.delegate_kv[each.value.rg_name].id
  role_definition_name = each.value.role
  principal_id         = var.azuread_groups.sub_owner.id
}

resource "azurerm_role_assignment" "ra_sub_aad_group_contributor" {
  for_each = {
    for pair in setproduct(
      [
        for rg in var.resource_group_configs : rg.common_name
        if rg.delegate_key_vault == true
      ],
      local.key_vault_rbac_roles.key_secret
      ) : "${pair[0]}-${pair[1]}" => {
      rg_name = pair[0]
      role    = pair[1]
    }
  }

  scope                = azurerm_key_vault.delegate_kv[each.value.rg_name].id
  role_definition_name = each.value.role
  principal_id         = var.azuread_groups.sub_contributor.id
}
