resource "kubernetes_cluster_role" "logs_ingress_nginx" {
  depends_on = [kubernetes_namespace.ingress_nginx]

  metadata {
    name = "logs-ingress-nginx"
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

resource "kubernetes_role_binding" "logs_ingress_nginx" {
  depends_on = [kubernetes_namespace.ingress_nginx]
  for_each   = { for ns in var.namespaces : ns.name => ns }

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