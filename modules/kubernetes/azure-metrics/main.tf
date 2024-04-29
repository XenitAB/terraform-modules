/**
  * # azure-metrics (azure-metrics)
  *
  * This module is used to query azure for metrics that we use to monitor our AKS clusters.
  * We are using: https://github.com/webdevops/azure-metrics-exporter to gather the metrics.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/azure-metrics.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "azure_metrics" {
  path = "platform/${var.cluster_id}/azure-metrics/azure-metrics.yaml"
  content = templatefile("${path.module}/templates/azure-metrics.yaml.tpl", {
    client_id               = var.client_id
    subscription_id         = var.subscription_id
    podmonitor_kubernetes   = var.podmonitor_kubernetes
    podmonitor_loadbalancer = var.podmonitor_loadbalancer
  })
}
