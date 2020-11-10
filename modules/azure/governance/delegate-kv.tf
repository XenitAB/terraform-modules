resource "azurerm_key_vault" "delegateKv" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  name                = "kv-${each.value.name}"
  location            = azurerm_resource_group.rg[each.value.name].location
  resource_group_name = azurerm_resource_group.rg[each.value.name].name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "delegateKvApOwnerSpn" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_service_principal.ownerSpn.id
  key_permissions    = var.key_vault_default_permissions.key_permissions
  secret_permissions = var.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "delegateKvApRgAadGroup" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_group.rg_contributor[each.value.resource_group_config.commonName].id
  key_permissions    = var.key_vault_default_permissions.key_permissions
  secret_permissions = var.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "delegateKvApRgSp" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if(env_resource.resource_group_config.delegate_key_vault == true && env_resource.resource_group_config.delegate_service_principal == true)
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_service_principal.aadSp[each.value.resource_group_config.commonName].object_id
  key_permissions    = var.key_vault_default_permissions.key_permissions
  secret_permissions = var.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "delegateKvApKvreaderSp" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_service_principal.delegateKvAadSp[each.value.resource_group_config.commonName].object_id
  key_permissions    = var.key_vault_default_permissions.key_permissions
  secret_permissions = var.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "delegateKvApSubAadGroupOwner" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_group.sub_owner.id
  key_permissions    = var.key_vault_default_permissions.key_permissions
  secret_permissions = var.key_vault_default_permissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "delegateKvApSubAadGroupContributor" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_key_vault == true
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_group.sub_contributor.id
  key_permissions    = var.key_vault_default_permissions.key_permissions
  secret_permissions = var.key_vault_default_permissions.secret_permissions
}
