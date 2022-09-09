terraform {}

provider "azurerm" {
  features {}
}

module "azpagent" {
  source = "../../../modules/azure/azure-pipelines-agent-vmss"

  environment     = "dev"
  location_short  = "we"
  unique_suffix   = "1234"
  name            = "azpagent"
  source_image_id = "/communityGalleries/xenit-d09d1810-7622-4864-9236-1a32035d35f0/images/azdo-agent/versions/1.0.0"
  vmss_sku        = "Standard_B2s"
  vmss_subnet_id  = "some_id"
}
