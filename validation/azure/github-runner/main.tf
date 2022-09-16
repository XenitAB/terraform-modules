terraform {}

provider "azurerm" {
  features {}
}

module "github_runner" {
  source = "../../../modules/azure/github-runner"

  environment     = "dev"
  location_short  = "we"
  name            = "ghrunner"
  source_image_id = "/communityGalleries/xenit-d09d1810-7622-4864-9236-1a32035d35f0/images/githu-runner/versions/1.0.0"
  vmss_sku        = "Standard_B2s"
  vmss_subnet_config = {
    name                 = "sn-dev-we-hub-servers"
    virtual_network_name = "vnet-dev-we-hub"
    resource_group_name  = "rg-dev-we-hub"
  }
}
