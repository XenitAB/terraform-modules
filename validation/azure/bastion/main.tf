terraform {
  required_version = "0.13.5"

  required_providers {
    azurerm = {
      version = "2.35.0"
      source  = "hashicorp/azurerm"
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
module "bastion" {
  source = "../../../modules/azure/bastion"

  environment = "dev"
  regions = [
    {
      location       = "West Europe"
      location_short = "we"
    }
  ]
  vnet_config = {
    we = {
      address_space = ["10.180.0.0/16"]
      subnets = [
        {
          name              = "servers"
          cidr              = "10.180.0.0/24"
          service_endpoints = []
        }
      ]
    }
  }

  bastion_subnet_config = {
    we = {
    
          name = "subnet1"
          cidr = "10.180.1.0/24"  
    }
  }

  vnet_name = "vnet-name"

  name = "name"

}
  