resource "azurerm_role_definition" "service_endpoint_join" {
  name  = "${var.azure_role_definition_prefix}-${var.environment}-${var.location_short}-${var.name}-${var.unique_suffix}-serviceEndpointJoin"
  scope = azurerm_virtual_network.this.id

  permissions {
    actions     = ["Microsoft.Network/virtualNetworks/subnets/joinViaServiceEndpoint/action"]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_virtual_network.this.id
  ]
}

data "azuread_group" "service_endpoint_join" {
  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}serviceEndpointJoin"
}

resource "azurerm_role_assignment" "service_endpoint_join" {
  scope              = azurerm_virtual_network.this.id
  role_definition_id = azurerm_role_definition.service_endpoint_join.role_definition_resource_id
  principal_id       = data.azuread_group.service_endpoint_join.id
}
