terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

provider "kubernetes" {
  load_config_file = "false"
}

provider "helm" {
  kubernetes {
    load_config_file = "false"
  }
}

module "csi_secrets_store_provider_azure" {
  source = "../../../modules/kubernetes/csi-secrets-store-provider-azure"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }
}
