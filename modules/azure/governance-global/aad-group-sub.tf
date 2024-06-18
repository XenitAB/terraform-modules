# AAD Group for Subscription Owners
data "azurecaf_name" "azuread_group_sub_owner" {
  name          = "owner"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.names.this.azuread_group_sub.prefixes
  suffixes      = module.names.this.azuread_group_sub.suffixes
  use_slug      = false
}

resource "azuread_group" "sub_owner" {
  display_name            = data.azurecaf_name.azuread_group_sub_owner.result
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azurerm_role_assignment" "sub_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.sub_owner.id
}

# AAD Group for Subscription Contributors
data "azurecaf_name" "azuread_group_sub_contributor" {
  name          = "contributor"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.names.this.azuread_group_sub.prefixes
  suffixes      = module.names.this.azuread_group_sub.suffixes
  use_slug      = false
}

resource "azuread_group" "sub_contributor" {
  display_name            = data.azurecaf_name.azuread_group_sub_contributor.result
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azurerm_role_assignment" "sub_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.sub_contributor.id
}

# AAD Group for Subscription Readers
data "azurecaf_name" "azuread_group_sub_reader" {
  name          = "reader"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.names.this.azuread_group_sub.prefixes
  suffixes      = module.names.this.azuread_group_sub.suffixes
  use_slug      = false
}

resource "azuread_group" "sub_reader" {
  display_name            = data.azurecaf_name.azuread_group_sub_reader.result
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azurerm_role_assignment" "sub_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.sub_reader.id
}
