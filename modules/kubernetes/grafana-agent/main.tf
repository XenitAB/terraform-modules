/**
 * # Grafana agent operator
 * 
 * Adds [`grafana-agent`](https://grafana.com/docs/agent/latest/) (the operator) amd
 * [`kube-state-metrics`](https://github.com/kubernetes/kube-state-metrics) to a Kubernetes clusters.
 *
*/

terraform {
  required_version = ">= 1.3.0"

  required_providers {
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
      name                = "grafana-agent"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "grafana-agent"
  }
}

resource "kubernetes_secret" "this" {
  depends_on = [kubernetes_namespace.this]

  metadata {
    name      = "grafana-agent-credentials"
    namespace = "grafana-agent"
  }

  data = {
    metrics_username = var.credentials.metrics_username
    metrics_password = var.credentials.metrics_password
    logs_username    = var.credentials.logs_username
    logs_password    = var.credentials.logs_password
    traces_username  = var.credentials.traces_username
    traces_password  = var.credentials.traces_password
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/grafana-agent.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "grafana_agent" {
  path = "platform/${var.cluster_id}/grafana-agent/grafana-agent.yaml"
  content = templatefile("${path.module}/templates/grafana-agent.yaml.tpl", {
  })
}

resource "git_repository_file" "grafana_agent_extras" {
  path = "platform/${var.cluster_id}/grafana-agent/grafana-agent-extras.yaml"
  content = templatefile("${path.module}/templates/grafana-agent-extras.yaml.tpl", {
    credentials_secret_name     = kubernetes_secret.this.metadata[0].name
    remote_write_metrics_url    = var.remote_write_urls.metrics
    remote_write_logs_url       = var.remote_write_urls.logs
    remote_write_traces_url     = var.remote_write_urls.traces
    environment                 = var.environment
    cluster_name                = var.cluster_name
    ingress_nginx_observability = tostring(contains(var.extra_namespaces, "ingress-nginx"))
    include_kubelet_metrics     = var.include_kubelet_metrics
    kubelet_metrics_namespaces  = join("|", compact(concat(var.namespace_include, var.extra_namespaces)))
  })
}

resource "git_repository_file" "kube_state_metrics" {
  path = "platform/${var.cluster_id}/grafana-agent/kube-state-metrics.yaml"
  content = templatefile("${path.module}/templates/kube-state-metrics.yaml.tpl", {
    namespaces_csv = join(",", compact(concat(var.namespace_include, var.extra_namespaces)))
  })
}
