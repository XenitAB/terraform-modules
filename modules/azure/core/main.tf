/**
  * # Core
  *
  * This module is used to create core resources like virtual network for the subscription.
  */

terraform {
  required_version = ">= 1.2.6"

  required_providers {
    azurerm = {
      version = "3.22.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.28.1"
      source  = "hashicorp/azuread"
    }
  }
}
