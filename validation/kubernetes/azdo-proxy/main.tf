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

module "azdo_proxy" {
  source = "../../../modules/kubernetes/azdo-proxy"

  providers = {
    azurerm    = azurem
    kubernetes = kubernetes
    helm       = helm
  }

  azure_devops_organization = "org"

  azure_devops_pat_keyvault = {
    read_azure_devops_pat_from_azure_keyvault = true
    azure_keyvault_id                         = "id"
    key                                       = "pat"
  }

  namespaces = [
    {
      name = "team1"
      flux = {
        enabled      = true
        azdo_org     = "org"
        azdo_project = "proj"
        azdo_repo    = "repo"
      }
    }
  ]
}
