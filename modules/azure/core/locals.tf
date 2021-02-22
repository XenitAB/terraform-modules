locals {
  subnets = [
    for subnet in var.vnet_config.subnets : {
      vnet_resource            = "${var.environment}-${var.name}"
      subnet_full_name         = "sn-${var.environment}-${var.location_short}-${var.name}-${subnet.name}"
      subnet_short_name        = subnet.name
      subnet_cidr              = subnet.cidr
      subnet_service_endpoints = subnet.service_endpoints
      subnet_aksSubnet         = subnet.aks_subnet
    }
  ]

  peerings = [
    for peering_config in var.peering_config : {
      name           = "${var.environment}-${var.location_short}-${var.name}-${peering_config.name}"
      peering_config = peering_config
    }
  ]
}
