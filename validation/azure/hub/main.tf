terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.35.0"
    }
    azuread = {
      version = "1.1.1"
      source  = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

module "hub" {
  source = "../../../modules/azure/hub"

  environment = "dev"
  regions = [
    {
      location       = "West Europe"
      location_short = "we"
    }
  ]
  subscription_name = "sub"
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
        name                         = "core-dev"
        remote_virtual_network_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-dev-we-core/providers/Microsoft.Network/virtualNetworks/vnet-dev-we-core"
        allow_forwarded_traffic      = true
        use_remote_gateways          = false
        allow_virtual_network_access = true
      },
    ]
  }
}
