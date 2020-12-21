/**
  * # Governance
  *
  * This module is used to create resource groups, service principals, Azure AD groups, Azure KeyVaults and delegation to all of those resources.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    azurerm = {
      version = "2.35.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.1.1"
      source  = "hashicorp/azuread"
    }
    random = {
      version = "3.0.0"
      source  = "hashicorp/random"
    }
    pal = {
      version = ">=0.0.0"
      source  = "xenitab/pal"
    }
  }
}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}
