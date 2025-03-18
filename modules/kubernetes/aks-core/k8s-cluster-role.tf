resource "kubernetes_cluster_role" "list_namespaces" {
  metadata {
    name = "list-namespaces"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "custom_resource_edit" {
  metadata {
    name = "custom-resource-edit"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = [
      "datadogmetrics.datadoghq.com",
      "datadogmonitors.datadoghq.com",
      "secrets-store.csi.x-k8s.io",
    ]
    resources = ["*"]
    verbs     = ["*"]
  }
}

resource "kubernetes_cluster_role" "top" {
  metadata {
    name = "top"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "trivy_reports" {
  for_each = {
    for s in ["trivy"] :
    s => s
    if var.platform_config.trivy_enabled
  }

  metadata {
    name = "trivy-reports"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["aquasecurity.github.io"]
    resources  = ["vulnerabilityreports"]
    verbs      = ["get", "list", "watch", "update", "delete"]
  }
}

resource "kubernetes_cluster_role" "get_nodes" {
  metadata {
    name = "get-nodes"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "get_vpa" {
  metadata {
    name = "get-vpa"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["autoscaling.k8s.io"]
    resources  = ["verticalpodautoscalers"]
    verbs      = ["get", "list", "watch"]
  }
}