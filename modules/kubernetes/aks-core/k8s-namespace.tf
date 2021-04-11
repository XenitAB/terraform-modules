resource "kubernetes_namespace" "service_accounts" {
  metadata {
    labels = {
      name = local.service_accounts_namespace
    }
    name = local.service_accounts_namespace
  }
}

resource "kubernetes_namespace" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    labels = merge(
      { for k, v in each.value.labels : k => v },
      {
        "name" = each.value.name,
        "xkf.xenit.io/kind" = "tenant"
      }
    )
    name = each.value.name
  }
}

resource "kubernetes_service_account" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = each.value.name
    namespace = kubernetes_namespace.service_accounts.metadata[0].name
  }
}

