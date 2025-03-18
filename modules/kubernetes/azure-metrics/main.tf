/**
  * # azure-metrics (azure-metrics)
  *
  * This module is used to query azure for metrics that we use to monitor our AKS clusters.
  * We are using: https://github.com/webdevops/azure-metrics-exporter to gather the metrics.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "azure_metrics" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/azure-metrics.yaml"
  content = templatefile("${path.module}/templates/azure-metrics.yaml.tpl", {
    client_id = azurerm_user_assigned_identity.azure_metrics.client_id,
  })
}

resource "git_repository_file" "monitors" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/azure-metrics/monitors.yaml"
  content = templatefile("${path.module}/templates/monitors.yaml.tpl", {
    subscription_id         = var.subscription_id,
    podmonitor_kubernetes   = var.podmonitor_kubernetes,
    podmonitor_loadbalancer = var.podmonitor_loadbalancer,
  })
}
