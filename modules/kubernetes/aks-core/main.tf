/**
  * # AKS Core
  *
  * This module is used to create AKS clusters.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    azurerm = {
      version = "2.72.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.6.0"
      source  = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.4.1"
    }
    github = {
      source  = "integrations/github"
      version = "4.13.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.2.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.11.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
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
