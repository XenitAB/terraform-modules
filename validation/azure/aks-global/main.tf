terraform {}

provider "azurerm" {
  features {}
}

module "aks_global" {
  source = "../../../modules/azure/aks-global"

  environment    = "dev"
  location       = "West Europe"
  location_short = "we"
  dns_zone       = ["example.io"]
}
