resource "kubernetes_role_binding" "k8sRbView" {
  depends_on = [kubernetes_namespace.k8sNs]
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "rb-${each.value.name}-view"
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

resource "kubernetes_role_binding" "k8sRbEdit" {
  depends_on = [kubernetes_namespace.k8sNs]
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "rb-${each.value.name}-edit"
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

resource "kubernetes_role_binding" "k8sRbCitrix" {
  depends_on = [kubernetes_namespace.k8sNs, kubernetes_cluster_role.citrix]
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "rb-${each.value.name}-citrix"
    namespace = each.value.name

    labels = {
      "aad-group-name" = var.aad_groups.edit[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "citrix"
  }
  subject {
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role_binding" "helmRelease" {
  depends_on = [
    kubernetes_namespace.k8sNs,
    kubernetes_cluster_role.helmRelease
  ]
  for_each = { for ns in var.namespaces : ns.name => ns }

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

resource "kubernetes_role_binding" "k8sRbSaEdit" {
  depends_on = [
    kubernetes_namespace.k8sSaNs,
    kubernetes_service_account.k8sSa
  ]
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "rb-sa-${each.value.name}-edit"
    namespace = each.value.name

  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.k8sSa[each.key].metadata[0].name
    namespace = local.service_account_namespace
  }
}

resource "kubernetes_role_binding" "k8sRbSaCitrix" {
  depends_on = [
    kubernetes_namespace.k8sSaNs,
    kubernetes_service_account.k8sSa,
    kubernetes_cluster_role.citrix
  ]
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "rb-sa-${each.value.name}-citrix"
    namespace = each.value.name

  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "citrix"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.k8sSa[each.key].metadata[0].name
    namespace = local.service_account_namespace
  }
}

resource "kubernetes_role_binding" "helmReleaseSa" {
  depends_on = [
    kubernetes_namespace.k8sSaNs,
    kubernetes_service_account.k8sSa,
    kubernetes_cluster_role.helmRelease
  ]
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "${each.value.name}-helm-release-sa"
    namespace = each.value.name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "helm-release"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.k8sSa[each.key].metadata[0].name
    namespace = local.service_account_namespace
  }
}
