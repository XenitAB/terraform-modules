resource "azurerm_subnet" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aks_subnet == false
  }

  name                                           = each.value.subnet_full_name
  resource_group_name                            = data.azurerm_resource_group.this.name
  virtual_network_name                           = azurerm_virtual_network.this.name
  address_prefixes                               = [each.value.subnet_cidr]
  service_endpoints                              = each.value.subnet_service_endpoints
  private_link_service_network_policies_enabled  = local.subnet_private_endpoints[each.value.subnet_short_name]
  private_endpoint_network_policies_enabled      = local.subnet_private_endpoints[each.value.subnet_short_name]
}

resource "azurerm_subnet" "aks" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aks_subnet == true
  }

  name                                           = each.value.subnet_full_name
  resource_group_name                            = data.azurerm_resource_group.this.name
  virtual_network_name                           = azurerm_virtual_network.this.name
  address_prefixes                               = [each.value.subnet_cidr]
  service_endpoints                              = each.value.subnet_service_endpoints
  private_link_service_network_policies_enabled  = local.subnet_private_endpoints[each.value.subnet_short_name]
  private_endpoint_network_policies_enabled      = local.subnet_private_endpoints[each.value.subnet_short_name]
}
