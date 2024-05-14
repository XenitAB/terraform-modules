terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azuread = {
      version = "2.49.1"
      source  = "hashicorp/azuread"
    }
    azurerm = {
      version = "3.103.1"
      source  = "hashicorp/azurerm"
    }
  }
}
