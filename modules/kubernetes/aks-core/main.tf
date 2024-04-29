/**
  * # AKS Core
  *
  * This module is used to create AKS clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "3.99.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.47.0"
      source  = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.34.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.25.3"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.name}"
}

data "azurerm_resource_group" "global" {
  name = "rg-${var.environment}-${var.global_location_short}-global"
}

locals {
  aks_name_suffix = var.aks_name_suffix != null ? var.aks_name_suffix : ""
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name_override == "" ? "acr${var.environment}${var.location_short}${var.name}${var.unique_suffix}" : var.acr_name_override
  resource_group_name = data.azurerm_resource_group.global.name
}

data "azurerm_user_assigned_identity" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  name                = "uai-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-${each.key}-wi"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_user_assigned_identity" "azure_metrics" {
  name                = "uai-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-azure-metrics-wi"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_user_assigned_identity" "external_dns" {
  name                = "uai-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-external-dns"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_user_assigned_identity" "cert_manager" {
  name                = "uai-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-cert-manager"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_user_assigned_identity" "datadog" {
  name                = "uai-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-datadog"
  resource_group_name = data.azurerm_resource_group.this.name
}

