data "azurecaf_name" "azurerm_role_definition_service_endpoint_join" {
  name          = var.name
  resource_type = "general"
  prefixes      = module.names.this.azurerm_role_definition.prefixes
  suffixes      = concat(module.names.this.azurerm_role_definition.suffixes, ["serviceEndpointJoin"])
  use_slug      = false
}

resource "azurerm_role_definition" "service_endpoint_join" {
  name  = data.azurecaf_name.azurerm_role_definition_service_endpoint_join.result
  scope = azurerm_virtual_network.this.id

  permissions {
    actions     = ["Microsoft.Network/virtualNetworks/subnets/joinViaServiceEndpoint/action"]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_virtual_network.this.id
  ]
}

data "azurecaf_name" "azuread_group_service_endpoint_join" {
  name          = "serviceEndpointJoin"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.names.this.azuread_group_sub.prefixes
  suffixes      = module.names.this.azuread_group_sub.suffixes
  use_slug      = false
}

data "azuread_group" "service_endpoint_join" {
  display_name = data.azurecaf_name.azuread_group_service_endpoint_join.result
}

resource "azurerm_role_assignment" "service_endpoint_join" {
  scope              = azurerm_virtual_network.this.id
  role_definition_id = azurerm_role_definition.service_endpoint_join.role_definition_resource_id
  principal_id       = data.azuread_group.service_endpoint_join.id
}
