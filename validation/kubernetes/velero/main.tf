terraform {}

provider "kubernetes" {}

provider "helm" {}

module "velero" {
  source = "../../../modules/kubernetes/velero"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  azure_config = {
    subscription_id           = "id"
    resource_group            = "name"
    storage_account_name      = "name"
    storage_account_container = "name"
    client_id                 = "id"
    resource_id               = "id"
  }
}
