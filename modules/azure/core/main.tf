/**
  * # Core
  *
  * This module is used to create core resources like virtual network for the subscription.
  */

terraform {
  required_version = ">= 1.2.6"

  required_providers {
    azurerm = {
      version = "3.8.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.19.1"
      source  = "hashicorp/azuread"
    }
  }
}
