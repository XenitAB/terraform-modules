resource "azurerm_virtual_network" "vnet" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  name                = "vnet-${each.value.name}"
  resource_group_name = data.azurerm_resource_group.rg[each.value.name].name
  location            = data.azurerm_resource_group.rg[each.value.name].location
  address_space       = each.value.vnet_config.address_space
}

resource "azurerm_virtual_network_peering" "peering" {
  for_each = {
    for peering_config in local.peerings :
    peering_config.name => peering_config
  }

  name                         = "peering-${each.value.name}"
  resource_group_name          = data.azurerm_resource_group.rg[each.value.env_resource_name].name
  virtual_network_name         = azurerm_virtual_network.vnet[each.value.env_resource_name].name
  remote_virtual_network_id    = each.value.peering_config.remote_virtual_network_id
  allow_forwarded_traffic      = each.value.peering_config.allow_forwarded_traffic
  use_remote_gateways          = each.value.peering_config.use_remote_gateways
  allow_virtual_network_access = each.value.peering_config.allow_virtual_network_access
}
