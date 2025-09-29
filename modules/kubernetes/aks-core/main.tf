/**
  * # AKS Core
  *
  * This module is used to create AKS clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.50.0"
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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.16.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
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

data "azuread_group" "aks_managed_identity" {
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}aksmsi"
}

locals {
  aks_name_suffix = var.aks_name_suffix != null ? var.aks_name_suffix : ""
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name_override == "" ? "acr${var.environment}${var.location_short}${var.name}${var.unique_suffix}" : var.acr_name_override
  resource_group_name = data.azurerm_resource_group.global.name
}

data "azurerm_key_vault" "core" {
  name                = var.keyvault_name_override == "" ? join("-", compact(["kv-${var.environment}-${var.location_short}-${var.core_name}", var.unique_suffix])) : var.keyvault_name_override
  resource_group_name = "rg-${var.environment}-${var.location_short}-${var.core_name}"
}

data "azurerm_user_assigned_identity" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  name                = "uai-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-${each.key}-wi"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_dns_zone" "this" {
  for_each = {
    for dns in var.dns_zones :
    dns => dns
    if var.external_dns_config.rbac_create
  }
  name                = each.key
  resource_group_name = data.azurerm_resource_group.global.name
}

data "azurerm_kubernetes_cluster" "this" {
  name                = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "kubernetes_resources" "bootstrap_token" {
  namespace      = "kube-system"
  kind           = "Secret"
  field_selector = "type=bootstrap.kubernetes.io/token"
  api_version    = "v1"
}

resource "git_repository_file" "platform_chart" {
  path = "platform/${var.platform_config.tenant_name}/${local.cluster_id}/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "platform_values" {
  path = "platform/${var.platform_config.tenant_name}/${local.cluster_id}/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

