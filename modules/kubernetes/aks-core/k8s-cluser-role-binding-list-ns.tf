resource "kubernetes_cluster_role_binding" "view_list_ns" {
  depends_on = [kubernetes_namespace.tenant]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name = "${each.value.name}-view-listns"

    labels = {
      "aad-group-name"    = var.aad_groups.view[each.key].name
      "xkf.xenit.io/kind" = "platform"
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

resource "kubernetes_cluster_role_binding" "edit_list_ns" {
  depends_on = [kubernetes_namespace.tenant]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name = "${each.value.name}-edit-listns"

    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
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
