/**
  * # AKS Core
  *
  * This module is used to create AKS clusters.
  */

terraform {
  required_version = ">= 1.2.6"

  required_providers {
    azurerm = {
      version = "3.22.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.28.1"
      source  = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.21.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.17.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
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

data "azurerm_resource_group" "global" {
  name = "rg-${var.environment}-${var.global_location_short}-global"
}
