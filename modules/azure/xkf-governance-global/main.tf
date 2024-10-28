terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azuread = {
      version = "2.50.0"
      source  = "hashicorp/azuread"
    }
    azurerm = {
      version = "3.110.0"
      source  = "hashicorp/azurerm"
    }
  }
}
