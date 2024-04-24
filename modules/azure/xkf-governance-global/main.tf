terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azuread = {
      version = "2.48.0"
      source  = "hashicorp/azuread"
    }
    azurerm = {
      version = "3.100.0"
      source  = "hashicorp/azurerm"
    }
  }
}
