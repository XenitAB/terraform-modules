resource "kubernetes_cluster_role" "list_namespaces" {
  metadata {
    name = "list-namespaces"
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "helm_release_v1" {
  metadata {
    name = "helm-release-v1"
  }
  rule {
    api_groups = ["helm.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "toolkit_helm_release" {
  metadata {
    name = "helm-release-v2"
  }
  rule {
    api_groups = ["helm.toolkit.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "toolkit_kustomization" {
  metadata {
    name = "helm-release-v2"
  }
  rule {
    api_groups = ["kustomize.toolkit.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["get, list, watch"]
  }
}
