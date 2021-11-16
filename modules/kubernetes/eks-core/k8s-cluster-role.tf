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
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }
}
