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

resource "kubernetes_cluster_role" "helm_release" {
  metadata {
    name = "helm-release"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["helm.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["*"]
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
      "helm.toolkit.fluxcd.io",
      "kustomize.toolkit.fluxcd.io",
      "source.toolkit.fluxcd.io",
      "notification.toolkit.fluxcd.io",
      "datadogmetrics.datadoghq.com",
      "datadogmonitors.datadoghq.com",
      "secrets-store.csi.x-k8s.io",
      "gateway.networking.k8s.io",
      "gateway.envoyproxy.io",
    ]
    resources = ["*"]
    verbs     = ["*"]
  }

  # Tenants manage the Argo CD resources that live in their own namespace.
  # Scoped to the resource kinds a tenant owns: argoproj.io also carries other
  # CRDs, and AppProjects define what a tenant may deploy, so they stay out.
  dynamic "rule" {
    for_each = var.platform_config.argocd_enabled ? [1] : []
    content {
      api_groups = ["argoproj.io"]
      resources  = ["applications", "applicationsets"]
      verbs      = ["*"]
    }
  }
  dynamic "rule" {
    for_each = var.platform_config.argocd_enabled ? [1] : []
    content {
      api_groups = ["argocd-image-updater.argoproj.io"]
      resources  = ["imageupdaters"]
      verbs      = ["*"]
    }
  }
}

resource "kubernetes_cluster_role" "argocd_view" {
  count = var.platform_config.argocd_enabled ? 1 : 0

  metadata {
    name = "argocd-view"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["argoproj.io"]
    resources  = ["applications", "applicationsets", "appprojects"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["argocd-image-updater.argoproj.io"]
    resources  = ["imageupdaters"]
    verbs      = ["get", "list", "watch"]
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