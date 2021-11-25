/**
  * # AZ-metrics (az-metrics)
  *
  * This module is used to query azure for metrics that we use to monitor our AKS clusters.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "az-metrics"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "az-metrics"
  }
}

resource "helm_release" "az_metrics_extras" {
  chart     = "${path.module}/charts/az-metrics-extras"
  name      = "az-metrics-extras"
  namespace = kubernetes_namespace.this.metadata[0].name

  set {
    name  = "resourceID"
    value = var.resource_id
  }

  set {
    name  = "clientID"
    value = var.client_id
  }
}
