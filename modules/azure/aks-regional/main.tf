/**
  * # Azure Kubernetes Service - Global
  *
  * This module is used to create resources that are used by AKS clusters.
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
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.1"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.name}"
}

data "azurerm_resource_group" "global" {
  name = "rg-${var.environment}-${var.global_location_short}-global"
}

data "azurerm_client_config" "current" {}
