terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.35.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "1.1.1"
    }
    pal = {
      source = "xenitab/pal"
      version = "0.2.3"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "pal" {}

module "governance" {
  source = "../../../modules/azure/governance"

  environment = "dev"
  regions = [
    {
      location       = "West Europe"
      location_short = "we"
    }
  ]
  subscription_name            = "xks"
  core_name                    = "core"
  unique_suffix                = "1234"
  owner_service_principal_name = "test"
  resource_group_configs = [
    {
      common_name                = "pkscore",
      delegate_aks               = false,
      delegate_key_vault         = true,
      delegate_service_endpoint  = false,
      delegate_service_principal = false,
      tags = {
        "description" = "Core infrastructure"
      }
    },
    {
      common_name                = "hub",
      delegate_aks               = false,
      delegate_key_vault         = true,
      delegate_service_endpoint  = false,
      delegate_service_principal = false,
      tags = {
        "description" = "Hub for SPOF infra"
      }
    },
    {
      common_name                = "azpagent",
      delegate_aks               = false,
      delegate_key_vault         = true,
      delegate_service_endpoint  = false,
      delegate_service_principal = false,
      tags = {
        "description" = "Azure Pipelines Agent"
      }
    },
    {
      common_name                = "aks",
      delegate_aks               = false,
      delegate_key_vault         = true,
      delegate_service_endpoint  = false,
      delegate_service_principal = false,
      tags = {
        "description" = "Azure Kubernetes Service"
      }
    },
    {
      common_name                = "team1",
      delegate_aks               = true,
      delegate_key_vault         = true,
      delegate_service_endpoint  = true,
      delegate_service_principal = true,
      tags = {
        "description" = "team1"
      }
    },
  ]
}
