/**
  * # Azure Kubernetes Service
  *
  * This module is used to create AKS clusters.
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    azurerm = {
      version = "2.47.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.3.0"
      source  = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.name}"
}

data "azurerm_resource_group" "aks" {
  name = azurerm_kubernetes_cluster.this.node_resource_group
}

data "azurerm_subnet" "this" {
  name                 = "sn-${var.environment}-${var.location_short}-${var.core_name}-${var.name}${var.aks_name_suffix}"
  virtual_network_name = "vnet-${var.environment}-${var.location_short}-${var.core_name}"
  resource_group_name  = "rg-${var.environment}-${var.location_short}-${var.core_name}"
}
