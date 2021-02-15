terraform {}

provider "azurerm" {
  features {}
}

module "github_runner" {
  source = "../../../modules/azure/github-runner"

  environment              = "dev"
  location_short           = "we"
  name                     = "ghrunner"
  github_runner_image_name = "github-runner-2020-11-16T22-24-11Z"
  vmss_sku                 = "Standard_B2s"
  vmss_subnet_config = {
    name                 = "sn-dev-we-hub-servers"
    virtual_network_name = "vnet-dev-we-hub"
    resource_group_name  = "rg-dev-we-hub"
  }
}
