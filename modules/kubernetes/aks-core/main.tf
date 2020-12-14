/**
  * # AKS Core
  *
  * This module is used to create AKS clusters.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    azurerm = {
      version = "2.35.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.0.0"
      source  = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    github = {
      source  = "hashicorp/github"
      version = "4.1.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.0.7"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.9.1"
    }
  }
}

locals {
  # Namespace to create service accounts in
  service_accounts_namespace = "service-accounts"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.name}"
}
