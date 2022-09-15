# Cluster Wide

resource "kubernetes_cluster_role" "tenant_view_cluster_wide" {
  metadata {
    name = "tenant-view-cluster-wide"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "tenant_view" {
  for_each   = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name = "tenant-view-${each.value.name}"
    labels = {
      "xkf.xenit.io/kind" = "platform"
      "aad-group-name"    = var.aad_groups.view[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.tenant_view_cluster_wide.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
  }
}

# Namespaced

resource "kubernetes_role_binding" "view" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "tenant-view"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name
    labels = {
      "xkf.xenit.io/kind" = "platform"
      "aad-group-name"    = var.aad_groups.view[each.key].name
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

resource "kubernetes_cluster_role" "tenant_view_namespaced" {
  metadata {
    name = "tenant-view-namespaced"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = [
      "aquasecurity.github.io",
      "autoscaling.k8s.io", 
    ]
    resources = ["*"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [
      "helm.fluxcd.io", # Remove when FluxV1 has been removed.
      "secrets-store.csi.x-k8s.io",
    ]
    resources = ["*"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [
      "helm.toolkit.fluxcd.io",
    ]
    resources = ["helmreleases"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [
      "kustomize.toolkit.fluxcd.io",
    ]
    resources = ["kustomizations"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [
      "source.toolkit.fluxcd.io",
    ]
    resources = [
      "buckets",
      "gitrepositories",
      "helmcharts",
      "helmrepositories",
      "ocirepositories",
    ]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [
      "notification.toolkit.fluxcd.io",
    ]
    resources = [
      "alerts",
      "providers",
      "receivers",
    ]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [
      "datadoghq.com",
    ]
    resources = [
      "datadogmetrics",
      "datadogmonitors",
    ]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [
      "secrets-store.csi.x-k8s.io",
    ]
    resources = [
      "secretproviderclasses",
      "secretproviderclasspodstatuses",
    ]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "tenant_view_namespaced" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "tenant-view"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name
    labels = {
      "xkf.xenit.io/kind" = "platform"
      "aad-group-name"    = var.aad_groups.edit[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.tenant_view_namespaced.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.view[each.key].id
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
  }
}

resource "kubernetes_role_binding" "tenant_edit" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "tenant-edit"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name
    labels = {
      "xkf.xenit.io/kind" = "platform"
      "aad-group-name"    = var.aad_groups.edit[each.key].name
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

resource "kubernetes_cluster_role" "tenant_edit_namespaced" {
  metadata {
    name = "tenant-edit-namespaced"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = [
      "helm.fluxcd.io", # Remove when FluxV1 has been removed.
      "helm.toolkit.fluxcd.io",
      "kustomize.toolkit.fluxcd.io",
      "source.toolkit.fluxcd.io",
      "notification.toolkit.fluxcd.io",
      "datadogmetrics.datadoghq.com",
      "datadogmonitors.datadoghq.com",
      "secrets-store.csi.x-k8s.io",
    ]
    resources = ["*"]
    verbs     = ["*"]
  }
}

resource "kubernetes_role_binding" "tenant_edit_namespaced" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "tenant-edit"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name
    labels = {
      "xkf.xenit.io/kind" = "platform"
      "aad-group-name"    = var.aad_groups.edit[each.key].name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.tenant_edit_namespaced.metadata[0].name
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.aad_groups.edit[each.key].id
  }
}
