resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aksSubnet == false
  }
  name                = "nsg-${var.environment}-${each.value.vnet_region}-${var.name}-${each.value.subnet_short_name}"
  location            = data.azurerm_resource_group.rg[each.value.vnet_resource].location
  resource_group_name = data.azurerm_resource_group.rg[each.value.vnet_resource].name
}

resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aksSubnet == false
  }
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
