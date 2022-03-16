/**
 * # Grafana Agent
 * Adds [`grafana-agent`](https://grafana.com/docs/agent/latest/) (the operator) to a Kubernetes clusters.
 *
*/

terraform {
  required_version = "0.15.3"

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
      name                = "grafana-agent"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "grafana-agent"
  }
}

locals {
  extras_values = templatefile("${path.module}/templates/extras-values.yaml.tpl", {
    environment     = var.environment
    cluster_name    = var.cluster_name
    cloud_provider  = var.cloud_provider
    remote_logs_url = var.remote_logs_url
    azure_config    = var.azure_config
  })

  operator_values = templatefile("${path.module}/templates/operator-values.yaml.tpl", {
    namespace = kubernetes_namespace.this.metadata[0].name
  })
}

resource "helm_release" "grafana_agent_operator" {
  repository  = "https://grafana.github.io/helm-charts"
  chart       = "grafana-agent-operator"
  name        = "grafana-agent-operator"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "0.1.5"
  max_history = 3

  values = [local.operator_values]
}

resource "helm_release" "grafana_agent_extras" {
  depends_on = [helm_release.grafana_agent_operator]

  chart       = "${path.module}/charts/grafana-agent-extras"
  name        = "grafana-agent-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  values      = [local.extras_values]
}
