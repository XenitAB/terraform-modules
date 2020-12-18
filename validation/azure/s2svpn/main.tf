terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.35.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "s2svpn" {
  source = "../../../modules/azure/s2svpn"

  environment = "dev"
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

local_gateway_address = "172.16.1.2"
local_gateway_address_space = [
  "172.16.0.0/22"
]
core_name       = "core"
vnet_name = "vnet-dev-we-core"

}

