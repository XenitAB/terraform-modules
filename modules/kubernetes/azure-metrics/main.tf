/**
  * # azure-metrics (azure-metrics)
  *
  * This module is used to query azure for metrics that we use to monitor our AKS clusters.
  * We are using: https://github.com/webdevops/azure-metrics-exporter to gather the metrics.
  */

terraform {
  required_version = ">= 1.1.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "azure-metrics"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "azure-metrics"
  }
}

resource "helm_release" "azure_metrics_extras" {
  chart       = "${path.module}/charts/azure-metrics-extras"
  name        = "azure-metrics-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3

  set {
    name  = "resourceID"
    value = var.resource_id
  }

  set {
    name  = "clientID"
    value = var.client_id
  }
}

resource "helm_release" "azure_metrics" {
  depends_on = [helm_release.azure_metrics_extras]

  chart       = "${path.module}/charts/azure-metrics-exporter"
  name        = "azure-metrics"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3

  set {
    name  = "subscription"
    value = var.subscription_id
  }
}
