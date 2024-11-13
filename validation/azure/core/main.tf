terraform {}

provider "azurerm" {
  features {}
}

provider "azuread" {}

module "core" {
  source = "../../../modules/azure/core"

  environment       = "dev"
  location_short    = "we"
  subscription_name = "xks"
  name              = "core"
  unique_suffix     = ""
  vnet_config = {
    address_space = ["10.180.0.0/16"]
    dns_servers   = []
    subnets = [
      {
        name              = "servers"
        cidr              = "10.180.0.0/24"
        service_endpoints = []
      },
      {
        name              = "aks1"
        cidr              = "10.180.1.0/24"
        service_endpoints = []
      },
      {
        name              = "aks2"
        cidr              = "10.180.2.0/24"
        service_endpoints = []
      },
    ]
  }
  peering_config = [
    {
      name                         = "hub"
      remote_virtual_network_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-dev-we-hub/providers/Microsoft.Network/virtualNetworks/vnet-dev-we-hub"
      allow_forwarded_traffic      = true
      use_remote_gateways          = false
      allow_virtual_network_access = true
    },
  ]
  route_config = [
    {
      subnet_name = "servers"
      routes = [
        {
          name                   = "default"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "Internet"
          next_hop_in_ip_address = ""
        },
        {
          name                   = "local_test"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "192.168.0.1"
        },
      ]
    },
  ]
  notification_email = "foo@example.com"
}
