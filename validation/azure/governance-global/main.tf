terraform {
  required_providers {
    pal = {
      source  = "xenitab/pal"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "pal" {}

module "governance-global" {
  source = "../../../modules/azure/governance-global"

  environment = "dev"
  subscription_name            = "xks"
  owner_service_principal_name = "test"
}
