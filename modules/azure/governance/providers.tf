# Configure the Azure Provider
provider "azurerm" {
  version = "=2.14.0"
  features {}
}

provider "azuread" {
  version = "=0.10.0"
}
