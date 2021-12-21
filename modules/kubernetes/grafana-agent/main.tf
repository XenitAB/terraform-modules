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

resource "helm_release" "grafana_agent_operator" {
  repository  = "https://grafana.github.io/helm-charts"
  chart       = "grafana-agent-operator"
  name        = "grafana-agent-operator"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "0.1.4"
  max_history = 3
}
