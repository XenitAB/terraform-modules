locals {
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

  # If subnet is not defined in var.subnet_private_endpoints default it to false
  subnet_private_endpoints = {
    for subnet in local.subnets : subnet.subnet_short_name => try(var.subnet_private_endpoints[subnet.subnet_short_name], false)
  }

  routes = flatten([
    for route_config in var.route_config : [
      for route in route_config.routes : {
        name        = "${route_config.subnet_name}-${route.name}"
        subnet_name = route_config.subnet_name
        route       = route
      }
    ]
  ])
}
