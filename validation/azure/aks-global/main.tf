terraform {}

provider "azurerm" {
  features {}
}

module "aks_global" {
  source = "../../../modules/azure/aks-global"

  environment          = "dev"
  location             = "West Europe"
  location_short       = "we"
  name                 = "xks"
  dns_zone             = ["example.io"]
  subscription_name    = "xks"
  unique_suffix        = "1234"
  aks_managed_identity = "id"
}
