/**
  * # Core
  *
  * This module is used to create core resources like virtual network for the subscription.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    #tf-latest-version:ignore
    azurerm = {
      version = "2.61.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.5.0"
      source  = "hashicorp/azuread"
    }
  }
}
