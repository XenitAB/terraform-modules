# AAD Group for Resource Group Owners
resource "azuread_group" "rg_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name            = "${var.azure_ad_group_prefix}-${var.location_short}-${var.subscription_name}-${var.environment}-${each.value.common_name}-owner"
  prevent_duplicate_names = true
  security_enabled        = true
}

# AAD Group for Resource Group Contributors
resource "azuread_group" "rg_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name            = "${var.azure_ad_group_prefix}-${var.location_short}-${var.subscription_name}-${var.environment}-${each.value.common_name}-contributor"
  prevent_duplicate_names = true
  security_enabled        = true
}


# AAD Group for Resource Group Readers
resource "azuread_group" "rg_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name            = "${var.azure_ad_group_prefix}-${var.location_short}-${var.subscription_name}-${var.environment}-${each.value.common_name}-reader"
  prevent_duplicate_names = true
  security_enabled        = true
}

# AAD Group for Resource Group Owners
resource "azurerm_role_assignment" "rg_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  scope                = azurerm_resource_group.rg[each.key].id
  role_definition_name = "Owner"
  principal_id         = var.azuread_groups.rg_owner[each.value.common_name].id
}

# AAD Group for Resource Group Contributors
resource "azurerm_role_assignment" "rg_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  scope                = azurerm_resource_group.rg[each.key].id
  role_definition_name = "Contributor"
  principal_id         = var.azuread_groups.rg_contributor[each.value.common_name].id
}

# AAD Group for Resource Group Readers
resource "azurerm_role_assignment" "rg_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  scope                = azurerm_resource_group.rg[each.key].id
  role_definition_name = "Reader"
  principal_id         = var.azuread_groups.rg_reader[each.value.common_name].id
}
