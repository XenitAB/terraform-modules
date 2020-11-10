# AAD Group for Subscription Owners
resource "azuread_group" "sub_owner" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}${var.environment}${local.groupNameSeparator}owner"
}

resource "azurerm_role_assignment" "sub_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.sub_owner.id
}

# AAD Group for Subscription Contributors
resource "azuread_group" "sub_contributor" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}${var.environment}${local.groupNameSeparator}contributor"
}

resource "azurerm_role_assignment" "sub_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.sub_contributor.id
}

# AAD Group for Subscription Readers
resource "azuread_group" "sub_reader" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}${var.environment}${local.groupNameSeparator}reader"
}

resource "azurerm_role_assignment" "sub_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.sub_reader.id
}
