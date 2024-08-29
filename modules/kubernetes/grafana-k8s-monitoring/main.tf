/**
  * # grafana-k8s-monitoring
  *
  * Adds [grafana-k8s-monitoring](https://github.com/grafana/k8s-monitoring-helm/tree/main/charts/k8s-monitoring) to a Kubernetes cluster.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "3.107.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "grafana-k8s-monitoring"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "grafana-k8s-monitoring"
  }
}

resource "git_repository_file" "kustomization" {
  path       = "clusters/${var.cluster_id}/grafana-k8s-monitoring.yaml"
  depends_on = [kubernetes_namespace.this]
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id,
  })
}

resource "git_repository_file" "grafana_k8s_monitoring" {
  path = "platform/${var.cluster_id}/grafana-k8s-monitoring/grafana-k8s-monitoring.yaml"
  content = templatefile("${path.module}/templates/grafana-k8s-monitoring.yaml.tpl", {
    grafana_k8s_monitor_config = var.grafana_k8s_monitor_config
    cluster_name               = var.cluster_name
    tenant_id                  = azurerm_user_assigned_identity.grafana_k8s_monitor.tenant_id,
    client_id                  = azurerm_user_assigned_identity.grafana_k8s_monitor.client_id,
    key_vault_name             = var.azure_config.azure_key_vault_name,
  })
}
