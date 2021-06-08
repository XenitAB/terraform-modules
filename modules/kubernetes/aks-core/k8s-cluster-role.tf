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

resource "kubernetes_cluster_role" "toolkit_helm" {
  metadata {
    name = "toolkit-helm"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["helm.toolkit.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "toolkit_kustomization" {
  metadata {
    name = "toolkit-kustomization"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["kustomize.toolkit.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "toolkit_source" {
  metadata {
    name = "toolkit-source"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["source.toolkit.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "toolkit_notification" {
  metadata {
    name = "toolkit-notification"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["notification.toolkit.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "datadog_edit" {
  metadata {
    name = "datadog-edit"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["datadogmetrics.datadoghq.com", "datadogmonitors.datadoghq.com"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}
