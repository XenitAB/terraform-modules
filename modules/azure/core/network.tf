  subnets = [
    for subnet in var.vnet_config.subnets : {
      vnet_resource            = "${var.environment}-${var.name}"
      subnet_full_name         = "sn-${var.environment}-${var.location_short}-${var.name}-${subnet.name}"
      subnet_short_name        = subnet.name
      subnet_cidr              = subnet.cidr
      subnet_service_endpoints = subnet.service_endpoints
      subnet_aks_subnet        = subnet.aks_subnet
    }
  ]


resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.environment}-${var.location_short}-${var.name}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  address_space       = var.vnet_config.address_space
  dns_servers         = var.vnet_config.dns_servers
}

resource "azurerm_virtual_network_peering" "this" {
  for_each = {
    for peering in var.peering_config :
    peering.name => peering
  }

  name           = "peering-${var.environment}-${var.location_short}-${var.name}-${peering_config.name}"
  resource_group_name          = data.azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = each.value.peering_config.remote_virtual_network_id
  allow_forwarded_traffic      = each.value.peering_config.allow_forwarded_traffic
  use_remote_gateways          = each.value.peering_config.use_remote_gateways
  allow_virtual_network_access = each.value.peering_config.allow_virtual_network_access
}




resource "azurerm_subnet" "aks" {
  for_each = {
    for subnet in var.vnet_config.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aks_subnet == true
  }

  name                                           = each.value.subnet_full_name
  resource_group_name                            = data.azurerm_resource_group.this.name
  virtual_network_name                           = azurerm_virtual_network.this.name
  address_prefixes                               = [each.value.subnet_cidr]
  service_endpoints                              = each.value.subnet_service_endpoints
  enforce_private_link_endpoint_network_policies = local.subnet_private_endpoints[each.value.subnet_short_name]
  enforce_private_link_service_network_policies  = local.subnet_private_endpoints[each.value.subnet_short_name]
}






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
  enforce_private_link_endpoint_network_policies = local.subnet_private_endpoints[each.value.subnet_short_name]
  enforce_private_link_service_network_policies  = local.subnet_private_endpoints[each.value.subnet_short_name]
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aks_subnet == false
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

resource "azurerm_network_security_group" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_aks_subnet == false
  }

  name                = "nsg-${var.environment}-${var.location_short}-${var.name}-${each.value.subnet_short_name}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_route_table" "this" {
  for_each = {
    for route in var.route_config :
    route.subnet_name => route
  }

  name                = "rt-${var.environment}-${var.location_short}-${var.name}-${each.value.subnet_name}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_route" "this" {
  for_each = {
    for route in local.routes :
    route.name => route
    if route.route.next_hop_type == "VirtualAppliance"
  }

  name                   = each.value.route.name
  resource_group_name    = data.azurerm_resource_group.this.name
  route_table_name       = azurerm_route_table.this[each.value.subnet_name].name
  address_prefix         = each.value.route.address_prefix
  next_hop_type          = each.value.route.next_hop_type
  next_hop_in_ip_address = each.value.route.next_hop_in_ip_address
}

# Note: In the future, we shouldn't use negated names but we have to do this
#       for now until `move` is supported (when we've updated to 1.1.0 or later):
#       https://github.com/hashicorp/terraform/releases/tag/v1.1.0
resource "azurerm_route" "not_virtual_appliance" {
  for_each = {
    for route in local.routes :
    route.name => route
    if route.route.next_hop_type != "VirtualAppliance"
  }

  name                = each.value.route.name
  resource_group_name = data.azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this[each.value.subnet_name].name
  address_prefix      = each.value.route.address_prefix
  next_hop_type       = each.value.route.next_hop_type
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = {
    for route in var.route_config :
    route.subnet_name => route
  }

  subnet_id      = azurerm_subnet.this["sn-${var.environment}-${var.location_short}-${var.name}-${each.value.subnet_name}"].id
  route_table_id = azurerm_route_table.this[each.value.subnet_name].id
}
