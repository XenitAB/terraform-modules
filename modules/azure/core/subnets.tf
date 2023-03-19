data "azurecaf_name" "azurerm_subnet_this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aks_subnet == false
  }

  name          = each.value.subnet_full_name
  resource_type = "azurerm_subnet"
  prefixes      = concat(module.names.this.azurerm_subnet.prefixes, [var.name])
  suffixes      = module.names.this.azurerm_subnet.suffixes
  use_slug      = false
}

# NOTE: Using the subnet_full_name here makes it weird referencing it from things like a route table.
#       Not sure what to do about it, but worth noting down for future reference.
resource "azurerm_subnet" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aks_subnet == false
  }

  name                                          = each.value.subnet_full_name
  resource_group_name                           = data.azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [each.value.subnet_cidr]
  service_endpoints                             = each.value.subnet_service_endpoints
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
}

resource "azurerm_subnet" "aks" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aks_subnet == true
  }

  name                                          = each.value.subnet_full_name
  resource_group_name                           = data.azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [each.value.subnet_cidr]
  service_endpoints                             = each.value.subnet_service_endpoints
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
}
