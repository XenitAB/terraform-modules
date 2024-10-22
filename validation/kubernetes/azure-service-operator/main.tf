terraform {}

provider "azurerm" {
  features {}
}

module "azure_service_operator" {
  source = "../../../modules/kubernetes/azure-service-operator"

  aks_name        = "aks"
  aks_name_suffix = "1"
  azure_service_operator_config = {
    cluster_config = {
      crd_pattern = "keyvault.azure.com/*;resources.azure.com/*"
    }
    tenant_namespaces = [
      { name = "mimforum" }
    ]
  }
  cluster_id      = "id"
  environment     = "env"
  location        = "location"
  location_short  = "we"
  oidc_issuer_url = "url"
  subscription_id = "id"
  tenant_id       = "id"
}