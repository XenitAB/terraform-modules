/**
  * # Core
  *
  * This module is used to create core resources like virtual network for the subscription.
  * This module assumes that you have a RG called `rg-<env>-<location_short>-log`.
  * Easiest is to define this RG in the governance module.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "3.38.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.28.1"
      source  = "hashicorp/azuread"
    }
  }
}
