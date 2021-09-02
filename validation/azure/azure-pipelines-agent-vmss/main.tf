terraform {}

provider "azurerm" {
  features {}
}

module "azpagent" {
  source = "../../../modules/azure/azure-pipelines-agent-vmss"

  environment                      = "dev"
  location_short                   = "we"
  unique_suffix                    = "1234"
  name                             = "azpagent"
  azure_pipelines_agent_image_name = "azp-agent-2020-11-16T22-24-11Z"
  vmss_sku                         = "Standard_B2s"
  vmss_subnet_id                   = "some_id"
}
