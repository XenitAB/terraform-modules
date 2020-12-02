locals {
  env_resources = { for region in var.regions : "${var.environment}-${region.location_short}-${var.name}" => {
    name        = "${var.environment}-${region.location_short}-${var.name}"
    environment = var.environment
    region      = region
    vnet_config = var.vnet_config[region.location_short]
    }
  }

  subnets = flatten([
    for region, vnet in var.vnet_config : [
      for subnet in vnet.subnets : {
        vnet_region              = region
        vnet_resource            = "${var.environment}-${region}-${var.name}"
        subnet_full_name         = "sn-${var.environment}-${region}-${var.name}-${subnet.name}"
        subnet_short_name        = subnet.name
        subnet_cidr              = subnet.cidr
        subnet_service_endpoints = subnet.service_endpoints
        subnet_aksSubnet         = subnet.aks_subnet
      }
    ]
  ])

  peerings = flatten([
    for region, peering_configs in var.peering_config : [
      for peering_config in peering_configs : {
        name              = "${var.environment}-${region}-${var.name}-${peering_config.name}"
        env_resource_name = "${var.environment}-${region}-${var.name}"
        peering_config    = peering_config
      }
    ]
  ])
}
