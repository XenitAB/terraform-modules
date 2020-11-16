resource "kubernetes_service_account" "group" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = each.value.name
    namespace = kubernetes_namespace.service_accounts.metadata[0].name
  }
}

data "kubernetes_secret" "group" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = kubernetes_service_account.group[each.key].default_secret_name
    namespace = kubernetes_namespace.service_accounts.metadata[0].name
  }
}

resource "azurerm_key_vault_secret" "group" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  name = "${var.name}-${each.value.name}-serviceaccount-kubeconfig"
  value = base64encode(jsonencode({
    apiVersion = "v1"
    kind       = "Config"
    clusters = [
      {
        cluster = {
          certificate-authority-data = base64encode(lookup(data.kubernetes_secret.group[each.key].data, "ca.crt"))
          server                     = azurerm_kubernetes_cluster.this.kube_config[0].host
        }
        name = ""
      }
    ]
    users = [
      {
        name = ""
        user = {
          token = data.kubernetes_secret.group[each.key].data.token
        }
      }
    ]
    contexts        = null
    current-context = ""
  }))
  key_vault_id = data.azurerm_key_vault.core.id
}

resource "azurerm_key_vault_secret" "group_rg" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  name = "${var.name}-${each.value.name}-serviceaccount-kubeconfig"
  value = base64encode(jsonencode({
    apiVersion = "v1"
    kind       = "Config"
    clusters = [
      {
        cluster = {
          certificate-authority-data = base64encode(lookup(data.kubernetes_secret.group[each.key].data, "ca.crt"))
          server                     = azurerm_kubernetes_cluster.this.kube_config[0].host
        }
        name = ""
      }
    ]
    users = [
      {
        name = ""
        user = {
          token = data.kubernetes_secret.group[each.key].data.token
        }
      }
    ]
    contexts        = null
    current-context = ""
  }))
  key_vault_id = data.azurerm_key_vault.rg[each.key].id
}
