/**
  * # Core
  *
  * This module is used to create core resources like virtual network for the subscription.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    azurerm = {
      version = "2.99.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.19.1"
      source  = "hashicorp/azuread"
    }
  }
}
