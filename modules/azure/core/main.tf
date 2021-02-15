/**
  * # Core
  *
  * This module is used to create core resources like virtual network for the subscription.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    azurerm = {
      version = "2.47.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.3.0"
      source  = "hashicorp/azuread"
    }
  }
}
