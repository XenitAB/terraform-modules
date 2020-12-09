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

module "datadog" {
  source = "../../../modules/kubernetes/datadog"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }

  api_key = "key" #tfsec:ignore:GEN003
  location = "foo"
  environment = "bar"
}
