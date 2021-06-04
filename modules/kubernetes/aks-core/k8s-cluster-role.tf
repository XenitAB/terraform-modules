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

resource "kubernetes_cluster_role" "toolkit_cr_permissions" {
  metadata {
    name = "toolkit-cr-permissions"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["*.toolkit.fluxcd.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "cert_manager_cr_permissions" {
  metadata {
    name = "cert-manager-cr-permissions"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = ["*.cert-manager.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}
