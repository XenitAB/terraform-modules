resource "azuread_application" "sub_reader_sp" {
  display_name = "${var.service_principal_name_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}reader"
}

resource "azuread_service_principal" "sub_reader_sp" {
  application_id = azuread_application.sub_reader_sp.application_id
}

resource "azurerm_role_assignment" "sub_reader_sp" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sub_reader_sp.object_id
}
