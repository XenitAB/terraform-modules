resource "kubernetes_namespace" "k8sNs" {
  for_each = { for ns in var.kubernetes_namespaces : ns.name => ns }

  metadata {
    labels = merge(
      { for k, v in each.value.labels : k => v },
      { "name" = each.value.name }
    )
    name = each.value.name
  }
}

resource "kubernetes_namespace" "k8sSaNs" {
  metadata {
    labels = {
      name = local.service_account_namespace
    }
    name = local.service_account_namespace
  }
}
