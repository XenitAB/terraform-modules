/**
  * # Governance (Global)
  *
  * This module is used for governance on a global level and not using any specific resource groups. Replaces the old `governance` together with `governance-regional`.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "3.110.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.50.0"
      source  = "hashicorp/azuread"
    }
    random = {
      version = "3.5.1"
      source  = "hashicorp/random"
    }
    pal = {
      version = "0.2.5"
      source  = "xenitab/pal"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "2.0.0-preview3"
    }
  }
}

data "azurerm_subscription" "current" {}

module "names" {
  source = "../names"

  resource_name_overrides       = var.resource_name_overrides
  azure_ad_group_prefix         = var.azure_ad_group_prefix
  aks_group_name_prefix         = var.aks_group_name_prefix
  service_principal_name_prefix = var.service_principal_name_prefix
  environment                   = var.environment
  subscription_name             = var.subscription_name
}
