locals {
  env_resources = { for region in var.regions : "${var.environment}-${region.location_short}-${var.name}" => {
    name        = "${var.environment}-${region.location_short}-${var.name}"
    environment = var.environment
    region      = region
    vnet_config = var.vnet_config[region.location_short]
    }
  }

  bastions = flatten([
    for region, subnet in var.bastion_subnet_config : {
      vnet_region   = region
      vnet_resource = "${var.environment}-${region}-${var.name}"
      subnet_name   = subnet.name
      subnet_cidr   = subnet.cidr
    }
  ])
}