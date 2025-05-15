terraform {}

provider "azurerm" {
  features {}
}

module "azure_policy" {
  source = "../../../modules/kubernetes/azure-policy"

  aks_name        = "aks"
  aks_name_suffix = 1
  azure_policy_config = {
    exclude_namespaces = []
    mutations          = []
  }
  environment    = "dev"
  location_short = "we"
}