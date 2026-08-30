terraform {
  required_version = ">= 1.11.0"
  required_providers {
    azuread = {
      version = "2.50.0"
      source  = "hashicorp/azuread"
    }
    azurerm = {
      version = "4.57.0"
      source  = "hashicorp/azurerm"
    }
  }
}
