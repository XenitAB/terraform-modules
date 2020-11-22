resource "kubernetes_cluster_role_binding" "view_tekton" {
  depends_on = [kubernetes_namespace.group]
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if var.tekton_operator_enabled
  }

  metadata {
    name = "${each.value.name}-view-tekton"

    labels = {
      "aad-group-name" = var.aad_groups.view[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "tekton-view"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "edit_tekton" {
  depends_on = [kubernetes_namespace.group]
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if var.tekton_operator_enabled
  }

  metadata {
    name = "${each.value.name}-edit-tekton"

    labels = {
      "aadGroup" = var.aad_groups.edit[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "tekton-edit"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}
