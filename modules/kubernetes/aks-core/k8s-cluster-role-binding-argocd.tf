resource "kubernetes_cluster_role_binding" "view_argocd" {
  depends_on = [kubernetes_namespace.tenant]
  for_each   = var.platform_config.argocd_enabled ? { for ns in var.namespaces : ns.name => ns } : {}

  metadata {
    name = "${each.value.name}-view-argocd"

    labels = {
      "aad-group-name"    = var.aad_groups.view[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.argocd_resource_view[0].metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "edit_argocd" {
  depends_on = [kubernetes_namespace.tenant]
  for_each   = var.platform_config.argocd_enabled ? { for ns in var.namespaces : ns.name => ns } : {}

  metadata {
    name = "${each.value.name}-edit-argocd"

    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.argocd_resource_edit[0].metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}
