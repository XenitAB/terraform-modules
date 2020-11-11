resource "azurerm_role_definition" "service_endpoint_join" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  name  = "role-${each.value.name}-serviceEndpointJoin"
  scope = azurerm_virtual_network.vnet[each.value.name].id

  permissions {
    actions     = ["Microsoft.Network/virtualNetworks/subnets/joinViaServiceEndpoint/action"]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_virtual_network.vnet[each.value.name].id
  ]
}

data "azuread_group" "service_endpoint_join" {
  name = "${local.aad_group_prefix}${local.group_name_separator}sub${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}serviceEndpointJoin"
}

resource "azurerm_role_assignment" "service_endpoint_join" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  scope              = azurerm_virtual_network.vnet[each.value.name].id
  role_definition_id = azurerm_role_definition.service_endpoint_join[each.value.name].id
  principal_id       = data.azuread_group.service_endpoint_join.id
}
