/**
  * # Azure Kubernetes Service
  *
  * This module is used to create AKS clusters.
  * The cluster is configured with a system pool that currently has a single node. The node is tainted
  * so that only kube-system pods can run on that system pool. This is partially to protect the system
  * critical pods from user applications and simplify scaling.
  * https://docs.microsoft.com/en-us/azure/aks/use-system-pools#system-and-user-node-pools
  *
  * Refer to the following docs for steps to replace the system node pool without recreating the cluster.
  * https://pumpingco.de/blog/modify-aks-default-node-pool-in-terraform-without-redeploying-the-cluster/
  *
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    azurerm = {
      version = "2.82.0"
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
  }
}

data "azurerm_client_config" "current" {}

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
