resource "kubernetes_cluster_role_binding" "k8sCrbClusterAdmin" {
  metadata {
    name = "crb-clusteradmin"

    labels = {
      "aadGroup" = local.aadGroups.aadGroupClusterAdmin.name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = local.aadGroups.aadGroupClusterAdmin.id
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "k8sCrbClusterView" {
  metadata {
    name = "crb-clusterview"

    labels = {
      "aadGroup" = local.aadGroups.aadGroupClusterView.name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  subject {
    kind      = "Group"
    name      = local.aadGroups.aadGroupClusterView.id
    api_group = "rbac.authorization.k8s.io"
  }
}
