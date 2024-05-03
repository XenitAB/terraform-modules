resource "kubernetes_role_binding" "view" {
  for_each = { for ns in var.namespaces : ns.name => ns }

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
  for_each = { for ns in var.namespaces : ns.name => ns }

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
  depends_on = [kubernetes_namespace.tenant, kubernetes_cluster_role.helm_release]
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
  for_each = { for ns in var.namespaces : ns.name => ns }

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
  for_each = { for ns in var.namespaces : ns.name => ns }
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
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if var.trivy_enabled
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

resource "kubernetes_role_binding" "logs_ingress_nginx" {
  for_each = { for ns in var.namespaces : ns.name => ns }
  metadata {
    name      = "${each.value.name}-logs-ingress-nginx"
    namespace = "ingress-nginx"
    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.logs_ingress_nginx.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
  }
}

resource "kubernetes_role_binding" "logs_external_dns" {
  for_each = { for ns in var.namespaces : ns.name => ns }
  metadata {
    name      = "${each.value.name}-logs-external-dns"
    namespace = "external-dns"
    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.logs_external_dns.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
  }
}
resource "kubernetes_role_binding" "logs_cert_manager" {
  for_each = { for ns in var.namespaces : ns.name => ns }
  metadata {
    name      = "${each.value.name}-logs-cert-manager"
    namespace = "cert-manager"
    labels = {
      "aad-group-name"    = var.aad_groups.edit[each.key].name
      "xkf.xenit.io/kind" = "platform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.logs_cert_manager.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
  }
}