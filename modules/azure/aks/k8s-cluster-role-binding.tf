resource "kubernetes_cluster_role_binding" "k8sCrbClusterAdmin" {
  metadata {
    name = "crb-clusteradmin"
    labels = {
      "aad-group-name" = var.aad_groups.cluster_admin.name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.cluster_admin.id
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "k8sCrbClusterView" {
  metadata {
    name = "crb-clusterview"
    labels = {
      "aad-group-name" = var.aad_groups.cluster_view.name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.cluster_view.id
    api_group = "rbac.authorization.k8s.io"
  }
}
