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

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

  providers = {
    helm = helm
  }

  notification_email = "example@example.com"
}
