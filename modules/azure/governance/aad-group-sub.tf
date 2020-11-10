# AAD Group for Subscription Owners
resource "azuread_group" "sub_owner" {
  name = "${local.aad_group_prefix}${local.group_name_separator}sub${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}owner"
}

resource "azurerm_role_assignment" "sub_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.sub_owner.id
}

# AAD Group for Subscription Contributors
resource "azuread_group" "sub_contributor" {
  name = "${local.aad_group_prefix}${local.group_name_separator}sub${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}contributor"
}

resource "azurerm_role_assignment" "sub_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.sub_contributor.id
}

# AAD Group for Subscription Readers
resource "azuread_group" "sub_reader" {
  name = "${local.aad_group_prefix}${local.group_name_separator}sub${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}reader"
}

resource "azurerm_role_assignment" "sub_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.sub_reader.id
}
