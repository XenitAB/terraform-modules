terraform {}

provider "azurerm" {
  features {}
}

provider "helm" {}

module "popeye" {
  source = "../../../modules/kubernetes/popeye"

  popeye_config = {
    storage_account = {
      resource_group_name = "my-resource-group-name"
      account_name        = "my-storage-account-name"
    }
    cron_jobs = [
      {
        namespace = "namespace-1"
        schedule  = "15 * * * 1"
      },
      {
        namespace = "namespace-2"
        schedule  = "20 * * * 1"
      }
    ]
  }

  aks_managed_identity_id = "some-UUID"
  cluster_id              = "my-cluster-id"
  location                = "westeurope"
  oidc_issuer_url         = "https://some-url"
  resource_group_name     = "aks-resource-group-name"
}