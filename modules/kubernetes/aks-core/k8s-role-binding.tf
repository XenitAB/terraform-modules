resource "kubernetes_role_binding" "view" {
  depends_on = [kubernetes_namespace.tenant]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "${each.value.name}-view"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

    labels = {
      "aad-group-name"    = var.aad_groups.view[each.key].name
      "xkf.xenit.io/kind" = "platform"
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
  depends_on = [kubernetes_namespace.tenant]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "${each.value.name}-edit"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
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
  depends_on = [kubernetes_namespace.tenant]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "${each.value.name}-helm-release"
    namespace = each.value.name

    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
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

resource "kubernetes_role_binding" "custom_resource_edit" {
  depends_on = [kubernetes_namespace.tenant]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "custom-resource-edit"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.custom_resource_edit.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
  }
}

resource "kubernetes_role_binding" "top" {
  depends_on = [kubernetes_namespace.tenant]
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "${each.value.name}-top"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name
    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.top.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
  }
}

resource "kubernetes_role_binding" "trivy_reports" {
  depends_on = [kubernetes_namespace.tenant]

  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if var.platform_config.trivy_enabled
  }

  metadata {
    name      = "${each.value.name}-trivy-reports"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.trivy_reports["trivy"].metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
  }
}

resource "kubernetes_role_binding" "vpa" {
  depends_on = [kubernetes_namespace.tenant]

  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }

  metadata {
    name      = "${each.value.name}-vpa"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.get_vpa.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
  }
}