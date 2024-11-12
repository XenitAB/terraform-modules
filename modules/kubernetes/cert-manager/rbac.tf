resource "kubernetes_cluster_role" "logs_cert_manager" {
  depends_on = [kubernetes_namespace.cert_manager]

  metadata {
    name = "logs-cert-manager"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["list", "view", "logs"]
  }
}

resource "kubernetes_role_binding" "logs_cert_manager" {
  depends_on = [kubernetes_namespace.cert_manager]
  for_each   = { for ns in var.namespaces : ns.name => ns }

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