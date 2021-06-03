/**
  * # AKS Core
  *
  * This module is used to create AKS clusters.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    azurerm = {
      version = "2.61.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.5.0"
      source  = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.3.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.10.1"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.1.8"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.11.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.2"
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
