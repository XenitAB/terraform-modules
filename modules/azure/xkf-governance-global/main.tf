terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azuread = {
      version = "2.47.0"
      source  = "hashicorp/azuread"
    }
    azurerm = {
      version = "3.99.0"
      source  = "hashicorp/azurerm"
    }
  }
}
