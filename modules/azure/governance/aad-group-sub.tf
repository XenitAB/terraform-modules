# AAD Group for Subscription Owners
resource "azuread_group" "sub_owner" {
  display_name                    = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}owner"
  prevent_duplicate_names = true
}

resource "azurerm_role_assignment" "sub_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.sub_owner.id
}

# AAD Group for Subscription Contributors
resource "azuread_group" "sub_contributor" {
  display_name                    = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}contributor"
  prevent_duplicate_names = true
}

resource "azurerm_role_assignment" "sub_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.sub_contributor.id
}

# AAD Group for Subscription Readers
resource "azuread_group" "sub_reader" {
  display_name                    = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}reader"
  prevent_duplicate_names = true
}

resource "azurerm_role_assignment" "sub_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.sub_reader.id
}
