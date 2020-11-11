# AAD Group for Resource Group Owners
resource "azuread_group" "rg_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  name = "${local.aad_group_prefix}${local.group_name_separator}rg${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}${each.value.common_name}${local.group_name_separator}owner"
  prevent_duplicate_names = true
}

resource "azurerm_role_assignment" "rg_owner" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Owner"
  principal_id         = azuread_group.rg_owner[each.value.resource_group_config.common_name].id
}

# AAD Group for Resource Group Contributors
resource "azuread_group" "rg_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  name = "${local.aad_group_prefix}${local.group_name_separator}rg${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}${each.value.common_name}${local.group_name_separator}contributor"
  prevent_duplicate_names = true
}

resource "azurerm_role_assignment" "rg_contributor" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.rg_contributor[each.value.resource_group_config.common_name].id
}

# AAD Group for Resource Group Readers
resource "azuread_group" "rg_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  name = "${local.aad_group_prefix}${local.group_name_separator}rg${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}${each.value.common_name}${local.group_name_separator}reader"
  prevent_duplicate_names = true
}

resource "azurerm_role_assignment" "rg_reader" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Reader"
  principal_id         = azuread_group.rg_reader[each.value.resource_group_config.common_name].id
}
