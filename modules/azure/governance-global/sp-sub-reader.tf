data "azurecaf_name" "azuread_application_sub_reader_sp" {
  name          = "reader"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.names.this.azuread_application_sub.prefixes
  suffixes      = module.names.this.azuread_application_sub.suffixes
  use_slug      = false
}

resource "azuread_application" "sub_reader_sp" {
  display_name = data.azurecaf_name.azuread_application_sub_reader_sp.result
}

resource "azuread_service_principal" "sub_reader_sp" {
  client_id = azuread_application.sub_reader_sp.client_id
}

resource "azurerm_role_assignment" "sub_reader_sp" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sub_reader_sp.object_id
}
