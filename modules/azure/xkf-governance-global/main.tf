terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azuread = {
      version = "2.28.1"
      source  = "hashicorp/azuread"
    }
    azurerm = {
      version = "3.24.0"
      source  = "hashicorp/azurerm"
    }
  }
}
