resource "kubernetes_cluster_role_binding" "cluster_admin" {
  metadata {
    name = "clusteradmin"
    labels = {
      "xkf.xenit.io/kind" = "platform"
      "aad-group-name"    = var.aad_groups.cluster_admin.name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.cluster_admin.id
  }
}

resource "kubernetes_cluster_role_binding" "cluster_view" {
  metadata {
    name = "clusterview"
    labels = {
      "xkf.xenit.io/kind" = "platform"
      "aad-group-name"    = var.aad_groups.cluster_view.name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.cluster_view.id
  }
}
