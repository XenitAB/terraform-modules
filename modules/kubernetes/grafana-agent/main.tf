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
      name                = "grafana-agent"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "grafana-agent"
  }
}

resource "kubernetes_secret" "this" {
  metadata {
    name      = "grafana-agent-credentials"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  data = {
    metrics_username = var.credentials.metrics_username
    metrics_password = var.credentials.metrics_password
    logs_username    = var.credentials.logs_username
    logs_password    = var.credentials.logs_password
  }
}

locals {
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    credentials_secret_name  = kubernetes_secret.this.metadata[0].name
    remote_write_metrics_url = var.remote_write_urls.metrics
    remote_write_logs_url    = var.remote_write_urls.logs
    environment              = var.environment
    cluster_name             = var.cluster_name
  })
}

resource "helm_release" "grafana_agent_operator" {
  repository  = "https://grafana.github.io/helm-charts"
  chart       = "grafana-agent-operator"
  name        = "grafana-agent-operator"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "0.1.4"
  max_history = 3

  set {
    name  = "kubeletService.namespace"
    value = kubernetes_namespace.this.metadata[0].name
  }
}

resource "helm_release" "grafana_agent_extras" {
  depends_on = [helm_release.grafana_agent_operator]

  chart       = "${path.module}/charts/grafana-agent-extras"
  name        = "grafana-agent-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  values      = [local.values]
}
