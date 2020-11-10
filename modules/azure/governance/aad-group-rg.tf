# AAD Group for Resource Group Owners
resource "azuread_group" "rg_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
  }

  name = "${local.aadGroupPrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}${var.environment}${local.groupNameSeparator}${each.value.commonName}${local.groupNameSeparator}owner"
}

resource "azurerm_role_assignment" "rg_owner" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Owner"
  principal_id         = azuread_group.rg_owner[each.value.resource_group_config.commonName].id
}

# AAD Group for Resource Group Contributors
resource "azuread_group" "rg_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
  }

  name = "${local.aadGroupPrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}${var.environment}${local.groupNameSeparator}${each.value.commonName}${local.groupNameSeparator}contributor"
}

resource "azurerm_role_assignment" "rg_contributor" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.rg_contributor[each.value.resource_group_config.commonName].id
}

# AAD Group for Resource Group Readers
resource "azuread_group" "rg_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
  }

  name = "${local.aadGroupPrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}${var.environment}${local.groupNameSeparator}${each.value.commonName}${local.groupNameSeparator}reader"
}

resource "azurerm_role_assignment" "rg_reader" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Reader"
  principal_id         = azuread_group.rg_reader[each.value.resource_group_config.commonName].id
}
