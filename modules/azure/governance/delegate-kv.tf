resource "azurerm_key_vault" "delegate_kv" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  name                = join("-", compact(["kv-${each.value.name}", var.unique_suffix]))
  location            = azurerm_resource_group.rg[each.value.name].location
  resource_group_name = azurerm_resource_group.rg[each.value.name].name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "ap_owner_spn" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_service_principal.owner_spn.id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_rg_aad_group" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_group.rg_contributor[each.value.resource_group_config.common_name].id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_rg_sp" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if(env_resource.resource_group_config.delegate_key_vault == true && env_resource.resource_group_config.delegate_service_principal == true)
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_service_principal.aad_sp[each.value.resource_group_config.common_name].object_id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_kvreader_sp" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_service_principal.delegate_kv_aad[each.value.resource_group_config.common_name].object_id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_sub_aad_group_owner" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_group.sub_owner.id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "ap_sub_aad_group_contributor" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegate_kv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_group.sub_contributor.id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}
