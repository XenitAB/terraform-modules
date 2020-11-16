resource "kubernetes_namespace" "group" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    labels = merge(
      { for k, v in each.value.labels : k => v },
      { "name" = each.value.name }
    )
    name = each.value.name
  }
}

resource "kubernetes_namespace" "service_accounts" {
  metadata {
    labels = {
      name = local.service_accounts_namespace
    }
    name = local.service_accounts_namespace
  }
}
