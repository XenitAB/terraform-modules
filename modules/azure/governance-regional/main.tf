/**
  * # Governance (Regional)
  *
  * This module is used for governance on a regional level and not using any specific resource groups. Replaces the old `governance` together with `governance-global`.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.7.0"
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
data "azurerm_client_config" "current" {}

module "names" {
  source = "../names"

  resource_name_overrides = var.resource_name_overrides
  environment             = var.environment
  location_short          = var.location_short
  unique_suffix           = var.unique_suffix
}
