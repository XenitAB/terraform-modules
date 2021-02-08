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

module "falco" {
  source = "../../../modules/kubernetes/falco"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }

  environment = "dev"
  datadog_api_key = "foobar" #tfsec:ignore:GEN003
}
