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

module "external_secrets" {
  source = "../../../modules/kubernetes/external-secrets"

  providers = {
    helm = helm
  }
}
