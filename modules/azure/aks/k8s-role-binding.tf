resource "kubernetes_role_binding" "view" {
  depends_on = [kubernetes_namespace.group]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "${each.value.name}-view"
    namespace = each.value.name

    labels = {
      "aad-group-name" = var.aad_groups.view[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role_binding" "edit" {
  depends_on = [kubernetes_namespace.group]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "${each.value.name}-edit"
    namespace = each.value.name

    labels = {
      "aad-group-name" = var.aad_groups.edit[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role_binding" "helm_release" {
  depends_on = [kubernetes_namespace.group, kubernetes_cluster_role.helm_release]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "${each.value.name}-helm-release"
    namespace = each.value.name

    labels = {
      "aad-group-name" = var.aad_groups.edit[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "helm-release"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role_binding" "sa_edit" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "sa-${each.value.name}-edit"
    namespace = each.value.name

  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.group[each.key].metadata[0].name
    namespace = kubernetes_namespace.service_accounts.metadata[0].name
  }
}

resource "kubernetes_role_binding" "sa_helm_release" {
  depends_on = [kubernetes_cluster_role.helm_release]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "sa-${each.value.name}-helm-release"
    namespace = each.value.name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "helm-release"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.group[each.key].metadata[0].name
    namespace = kubernetes_namespace.service_accounts.metadata[0].name
  }
}
