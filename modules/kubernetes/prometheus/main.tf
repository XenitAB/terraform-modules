/**
  * # Prometheus
  *
  * Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.0"
    }
  }
}

locals {
  namespace         = "prometheus"
  values_prometheus = templatefile("${path.module}/templates/values.yaml.tpl", {})
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = local.namespace
    }
    name = local.namespace
  }
}

resource "helm_release" "prometheus" {
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  name       = "prometheus"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "14.6.2"
  values     = [local.values_prometheus]
}

resource "helm_release" "prometheus_extras" {
  depends_on = [helm_release.prometheus]
  chart      = "${path.module}/charts/prometheus-extras"
  name       = "prometheus-extras"
  namespace  = kubernetes_namespace.this.metadata[0].name
  values = [templatefile("${path.module}/templates/values-extras.yaml.tpl", {
    alertmanager_enabled   = var.alertmanager_enabled
    remote_write_enabled   = var.remote_write_enabled
    remote_write_url       = var.remote_write_url
    remote_tls_secret_name = var.remote_tls_secret_name

    volume_claim_enabled            = var.volume_claim_enabled
    volume_claim_storage_class_name = var.volume_claim_storage_class_name
    volume_claim_size               = var.volume_claim_size
  })]
}
