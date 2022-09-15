# This is here for legacy support for those who have not migrated to deploying with GitOps yet.
# The service account is used by pipelines to authenticate with the cluster when deploying.
# Should be removed when all end users use GitOps.

resource "kubernetes_namespace" "service_accounts" {
  metadata {
    labels = {
      name = "service-accounts"
    }
    name = "service-accounts"
  }
}

resource "kubernetes_service_account" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = each.value.name
    namespace = kubernetes_namespace.service_accounts.metadata[0].name
  }
}

resource "kubernetes_role_binding" "sa_edit" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "sa-${each.value.name}-edit"
    namespace = each.value.name
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
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
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
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

resource "kubernetes_role_binding" "sa_custom_resource" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "sa-${each.value.name}-custom-resource"
    namespace = each.value.name
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.custom_resource_edit.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tenant[each.key].metadata[0].name
    namespace = kubernetes_namespace.service_accounts.metadata[0].name
  }
}
