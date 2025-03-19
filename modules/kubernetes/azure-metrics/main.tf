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
    client_id = azurerm_user_assigned_identity.azure_metrics.client_id
    project   = var.fleet_infra_config.argocd_project_name
    server    = var.fleet_infra_config.k8s_api_server_url
  })
}
