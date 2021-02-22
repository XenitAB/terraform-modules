# AAD Group for Resource Group Owners
data "azuread_group" "rg_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.common_name}${var.group_name_separator}owner"
}

resource "azurerm_role_assignment" "rg_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  scope                = azurerm_resource_group.rg[each.key].id
  role_definition_name = "Owner"
  principal_id         = data.azuread_group.rg_owner[each.value.common_name].id
}

# AAD Group for Resource Group Contributors
data "azuread_group" "rg_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.common_name}${var.group_name_separator}contributor"
}

resource "azurerm_role_assignment" "rg_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  scope                = azurerm_resource_group.rg[each.key].id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_group.rg_contributor[each.value.common_name].id
}

# AAD Group for Resource Group Readers
data "azuread_group" "rg_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.common_name}${var.group_name_separator}reader"
}

resource "azurerm_role_assignment" "rg_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  scope                = azurerm_resource_group.rg[each.key].id
  role_definition_name = "Reader"
  principal_id         = data.azuread_group.rg_reader[each.value.common_name].id
}
