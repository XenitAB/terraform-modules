resource "kubernetes_cluster_role_binding" "k8sCrbViewListNs" {
  depends_on = [kubernetes_namespace.k8sNs]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name = "crb-${each.value.name}-view-listns"

    labels = {
      "aad-group-name" = var.aad_groups.view[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "list-namespaces"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "k8sCrbEditListNs" {
  depends_on = [kubernetes_namespace.k8sNs]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name = "crb-${each.value.name}-edit-listns"

    labels = {
      "aadGroup" = var.aad_groups.edit[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "list-namespaces"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}
