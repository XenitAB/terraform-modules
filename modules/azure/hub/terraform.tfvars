environment = "prod"
regions = [
  {
    location       = "West Europe"
    location_short = "we"
  }
]

name = "hub"

vnet_config = {
  we = {
    address_space = ["172.16.0.0/22"]
    subnets = [
      {
        name              = "servers"
        cidr              = "172.16.0.0/25"
        service_endpoints = []
      },
    ]
  }
}


peering_config = {
  we = [
    {
      name                         = "dev"
      remote_virtual_network_id    = "/subscriptions/.../resourceGroups/rg-dev-we-core/providers/Microsoft.Network/virtualNetworks/vnet-dev-we-core"
      allow_forwarded_traffic      = true
      use_remote_gateways          = false
      allow_virtual_network_access = true
    },
    {
      name                         = "qa"
      remote_virtual_network_id    = "/subscriptions/.../resourceGroups/rg-qa-we-core/providers/Microsoft.Network/virtualNetworks/vnet-qa-we-core"
      allow_forwarded_traffic      = true
      use_remote_gateways          = false
      allow_virtual_network_access = true
    },
    {
      name                         = "prod"
      remote_virtual_network_id    = "/subscriptions/.../resourceGroups/rg-prod-we-core/providers/Microsoft.Network/virtualNetworks/vnet-prod-we-core"
      allow_forwarded_traffic      = true
      use_remote_gateways          = false
      allow_virtual_network_access = true
    },
  ]
}


