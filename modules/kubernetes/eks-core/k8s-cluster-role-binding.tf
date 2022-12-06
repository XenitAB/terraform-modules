resource "kubernetes_cluster_role_binding" "cluster_admin" {
  metadata {
    name = "clusteradmin"
    labels = {
      "aad-group-name"    = var.aad_groups.cluster_admin.name
      "xkf.xenit.io/kind" = "platform"
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

resource "kubernetes_cluster_role_binding" "cluster_view" {
  metadata {
    name = "clusterview"
    labels = {
      "aad-group-name"    = var.aad_groups.cluster_view.name
      "xkf.xenit.io/kind" = "platform"
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

resource "kubernetes_cluster_role_binding" "get_node" {
  for_each = { for ns in var.namespaces : ns.name => ns }
  metadata {
    name = "${each.value.name}-get-node"
    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.get_node.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
  }
}
