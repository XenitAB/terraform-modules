/**
  * # Governance (Regional)
  *
  * This module is used for governance on a regional level and not using any specific resource groups. Replaces the old `governance` together with `governance-global`.
  */

terraform {
  required_version = ">= 1.1.7"

  required_providers {
    azurerm = {
      version = "3.1.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.19.1"
      source  = "hashicorp/azuread"
    }
    random = {
      version = "3.1.0"
      source  = "hashicorp/random"
    }
    pal = {
      version = "0.2.5"
      source  = "xenitab/pal"
    }
  }
}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}
