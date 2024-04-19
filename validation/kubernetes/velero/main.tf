terraform {}

provider "kubernetes" {}

provider "helm" {}

module "azure_velero" {
  source = "../../../modules/azure/aks-regional/velero"

  aks_managed_identity = "uai"
  location_short       = "short"
  name                 = "name"
  environment          = "env"
  unique_suffix        = "suffix"
}

module "velero" {
  source = "../../../modules/kubernetes/velero"

  cluster_id = "we-dev-aks1"

  azure_config = {
    subscription_id           = "id"
    resource_group            = "name"
    storage_account_name      = "name"
    storage_account_container = "name"
    client_id                 = "id"
    resource_id               = "id"
  }
}
