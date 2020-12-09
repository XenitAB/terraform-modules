resource "kubernetes_role_binding" "view" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "${each.value.name}-view"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

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
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
  }
}

resource "kubernetes_role_binding" "edit" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "${each.value.name}-edit"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

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
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
  }
}

resource "kubernetes_role_binding" "helm_release" {
  depends_on = [kubernetes_namespace.tenant, kubernetes_cluster_role.helm_release]
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

resource "kubernetes_role_binding" "toolkit_helm_release" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "toolkit-helm-release"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

    labels = {
      "aad-group-name" = var.aad_groups.edit[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.toolkit_helm_release.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
  }
}

resource "kubernetes_role_binding" "toolkit_kustomization" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "toolkit-kustomization"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

    labels = {
      "aad-group-name" = var.aad_groups.edit[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.toolkit_kustomization.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
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
    name      = kubernetes_service_account.tenant[each.key].metadata[0].name
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
    name      = kubernetes_service_account.tenant[each.key].metadata[0].name
    namespace = kubernetes_namespace.service_accounts.metadata[0].name
  }
}
