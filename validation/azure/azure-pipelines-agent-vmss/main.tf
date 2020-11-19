terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.35.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "azpagent" {
  source = "../../../modules/azure/azure-pipelines-agent-vmss"

  environment                      = "dev"
  location_short                   = "we"
  name                             = "azpagent"
  azure_pipelines_agent_image_name = "azp-agent-2020-11-16T22-24-11Z"
  vmss_sku                         = "Standard_B2s"
  vmss_subnet_config = {
    name                 = "sn-dev-we-hub-servers"
    virtual_network_name = "vnet-dev-we-hub"
    resource_group_name  = "rg-dev-we-hub"
  }
}
