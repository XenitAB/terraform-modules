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
