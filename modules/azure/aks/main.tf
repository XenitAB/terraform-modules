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
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "3.110.0"
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
  }
}

data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.name}"
}