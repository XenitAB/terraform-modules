terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

provider "helm" {
  kubernetes {
    load_config_file = "false"
  }
}

module "velero" {
  source = "../../../modules/kubernetes/velero"

  providers = {
    helm = helm
  }

  cloud_provider                  = "azure"
  azure_subscription_id           = "id"
  azure_resource_group            = "name"
  azure_storage_account_name      = "name"
  azure_storage_account_container = "name"
  azure_client_id                 = "id"
  azure_resource_id               = "id"
}
