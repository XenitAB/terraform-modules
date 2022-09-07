/**
  * # Governance (Global)
  *
  * This module is used for governance on a global level and not using any specific resource groups. Replaces the old `governance` together with `governance-regional`.
  */

terraform {
  required_version = ">= 1.2.6"

  required_providers {
    azurerm = {
      version = "3.21.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.28.1"
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
