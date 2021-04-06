resource "kubernetes_limit_range" "this" {
  for_each = { for ns in var.namespaces : ns.name => ns }
  depends_on = [kubernetes_namespace.tenant]

  metadata {
    name      = "default"
    namespace = each.key
  }

  spec {
    limit {
      type = "Container"
      default_request = {
        cpu    = var.kubernetes_default_limit_range.default_request.cpu
        memory = var.kubernetes_default_limit_range.default_request.memory
      }
      default = {
        memory = var.kubernetes_default_limit_range.default.memory
      }
    }
  }
}
