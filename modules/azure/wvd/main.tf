/**
  * # Windows Virtual Desktop
  *
  * This module is used to create Windows Virtual Desktop.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    azurerm = {
      version = "2.47.0"
      source  = "hashicorp/azurerm"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.name}"
}


