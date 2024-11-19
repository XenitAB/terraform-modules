# NOTE: Using the subnet_full_name here makes it weird referencing it from things like a route table.
#       Not sure what to do about it, but worth noting down for future reference.
resource "azurerm_subnet" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
  }

  name                                          = each.value.subnet_full_name
  resource_group_name                           = data.azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [each.value.subnet_cidr]
  service_endpoints                             = each.value.subnet_service_endpoints
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies             = "Enabled"
}
