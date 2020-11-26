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
  azure_config = {
    subscription_id           = "id"
    resource_group            = "name"
    storage_account_name      = "name"
    storage_account_container = "name"
    client_id                 = "id"
    resource_id               = "id"
  }
}
