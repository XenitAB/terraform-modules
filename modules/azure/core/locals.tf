data "azurecaf_name" "local_subnets_subnet_full_name" {
  for_each = {
    for subnet in var.vnet_config.subnets :
    subnet.name => subnet
  }

  name          = each.value.name
  resource_type = "azurerm_subnet"
  prefixes      = concat(module.names.this.azurerm_subnet.prefixes, [var.name])
  suffixes      = module.names.this.azurerm_subnet.suffixes
  use_slug      = false
}

data "azurecaf_name" "local_peerings_name" {
  for_each = {
    for peering_config in var.peering_config :
    peering_config.name => peering_config
  }

  name          = each.value.name
  resource_type = "azurerm_virtual_network_peering"
  prefixes      = concat(module.names.this.azurerm_virtual_network_peering.prefixes, [var.name])
  suffixes      = module.names.this.azurerm_virtual_network_peering.suffixes
  use_slug      = false
}

locals {
  subnets = [
    for subnet in var.vnet_config.subnets : {
      vnet_resource            = "${var.environment}-${var.name}"
      subnet_full_name         = data.azurecaf_name.local_subnets_subnet_full_name[subnet.name].result
      subnet_short_name        = subnet.name
      subnet_cidr              = subnet.cidr
      subnet_service_endpoints = subnet.service_endpoints
      subnet_create_nsg        = subnet.create_nsg
    }
  ]

  peerings = [
    for peering_config in var.peering_config : {
      name           = "${var.environment}-${var.location_short}-${var.name}-${peering_config.name}"
      full_name      = data.azurecaf_name.local_peerings_name[peering_config.name].result
      peering_config = peering_config
    }
  ]

  routes = flatten([
    for route_config in var.route_config : [
      for route in route_config.routes : {
        name        = "${route_config.subnet_name}-${route.name}"
        subnet_name = route_config.subnet_name
        route       = route
      }
    ]
  ])
  security_rules = flatten([
    for subnet in var.vnet_config.subnets : [
      for security_rule in subnet.security_rules : {
        subnet_create_nsg               = subnet.create_nsg
        nsg_full_name                   = data.azurecaf_name.local_subnets_subnet_full_name[subnet.name].result
        rule_name                       = security_rule.name
        rule_priority                   = security_rule.priority
        rule_direction                  = security_rule.direction
        rule_access                     = security_rule.access
        rule_protocol                   = security_rule.protocol
        rule_source_port_range          = security_rule.source_port_range
        rule_destination_port_range     = security_rule.destination_port_range
        rule_source_address_prefix      = security_rule.source_address_prefix
        rule_destination_address_prefix = security_rule.destination_address_prefix

      }
    ]
  ])
}
