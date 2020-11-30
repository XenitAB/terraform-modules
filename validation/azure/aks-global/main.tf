terraform {
  required_providers {
    azurerm = {
      version = "2.35.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.0.0"
      source  = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "random" {}

provider "tls" {}

module "aks_global" {
  source = "../../../modules/azure/aks-global"

  environment       = "dev"
  location_short    = "we"
  name              = "xks"
  subscription_name = "xks"
  core_name         = "core"
  unique_suffix     = "1234"
  namespaces = [
    {
      name                    = "team1"
      delegate_resource_group = true
      labels = {
        "test" = "test"
      }
      flux = {
        enabled      = true
        repo    = "repo"
      }
    }
  ]

  dns_zone           = "example.io"
  aks_authorized_ips = ["0.0.0.0/0"]
}
