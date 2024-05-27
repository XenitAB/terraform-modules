terraform {}

provider "kubernetes" {}

provider "helm" {}

module "velero" {
  source = "../../../modules/kubernetes/velero"

  aks_managed_identity = "id"
  azure_config = {
    storage_account_name      = "name"
    storage_account_container = "name"
  }
  cluster_id          = "we-dev-aks1"
  environment         = "dev"
  location            = "we"
  oidc_issuer_url     = "url"
  resource_group_name = "rg-name"
  subscription_id     = "id"
  unique_suffix       = "1234"
}
