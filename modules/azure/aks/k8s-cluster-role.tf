resource "kubernetes_cluster_role" "citrix" {
  metadata {
    name = "citrix"
  }

  rule {
    api_groups = ["citrix.com"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "listNamespaces" {
  metadata {
    name = "list-namespaces"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "helmRelease" {
  metadata {
    name = "helm-release"
  }

  rule {
    api_groups = ["helm.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}
