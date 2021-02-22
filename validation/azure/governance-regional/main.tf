terraform {
  required_providers {
    pal = {
      source  = "xenitab/pal"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "pal" {}

module "governance-regional" {
  source = "../../../modules/azure/governance-regional"

  environment = "dev"
  location_short = "we"
  location = "West Europe"
  core_name = "core"
  subscription_name            = "xks"
  owner_service_principal_name = "test"
  resource_group_configs = [
    {
      common_name                = "core",
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
