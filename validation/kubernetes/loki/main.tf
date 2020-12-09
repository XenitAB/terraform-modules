terraform {
  required_providers {
    azurerm = {
      version = "2.35.0"
      source  = "hashicorp/azurerm"
    }
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

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  load_config_file = "false"
}


provider "helm" {
  kubernetes {
    load_config_file = "false"
  }
}

module "loki" {
  source = "../../../modules/kubernetes/loki"

  providers = {
    azurerm = azurerm
    kubernetes = kubernetes
    helm    = helm
  }

  environment    = "dev"
  location_short = "we"
  name           = "xks"
}
