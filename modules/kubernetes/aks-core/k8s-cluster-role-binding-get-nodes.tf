resource "kubernetes_cluster_role_binding" "get-nodes" {
  depends_on = [kubernetes_namespace.tenant]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name = "${each.value.name}-get-nodes"

    labels = {
      "aad-group-name"    = var.aad_groups.view[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "get-nodes"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}
