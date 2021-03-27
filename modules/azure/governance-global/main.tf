/**
  * # Governance (Global)
  *
  * This module is used for governance on a global level and not using any specific resource groups. Replaces the old `governance` together with `governance-regional`.
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    azurerm = {
      version = "2.53.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.4.0"
      source  = "hashicorp/azuread"
    }
    random = {
      version = "3.1.0"
      source  = "hashicorp/random"
    }
    pal = {
      version = "0.2.4"
      source  = "xenitab/pal"
    }
  }
}

data "azurerm_subscription" "current" {}
