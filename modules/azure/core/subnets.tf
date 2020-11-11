resource "azurerm_subnet" "subnet" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aksSubnet == false
  }
  name                 = each.value.subnet_full_name
  resource_group_name  = data.azurerm_resource_group.rg[each.value.vnet_resource].name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_resource].name
  address_prefixes     = [each.value.subnet_cidr]
  service_endpoints    = each.value.subnet_service_endpoints
}

resource "azurerm_subnet" "subnet_aks" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aksSubnet == true
  }
  name                 = each.value.subnet_full_name
  resource_group_name  = data.azurerm_resource_group.rg[each.value.vnet_resource].name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_resource].name
  address_prefixes     = [each.value.subnet_cidr]
  service_endpoints    = each.value.subnet_service_endpoints
}
