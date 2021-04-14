resource "helm_release" "xenit_proxy_extras" {
  chart     = "${path.module}/charts/xenit-proxy-extras"
  name      = "xenit-proxy-extras"
  namespace = kubernetes_namespace.this.metadata[0].name

  set {
    name  = "resourceID"
    value = var.xenit_config.identity.resource_id
  }

  set {
    name  = "clientID"
    value = var.xenit_config.identity.client_id
  }

  set {
    name  = "tenantID"
    value = var.xenit_config.identity.tenant_id
  }

  set {
    name  = "keyVaultName"
    value = var.xenit_config.azure_key_vault_name
  }
}

resource "helm_release" "xenit_proxy" {
  depends_on = [helm_release.xenit_proxy_extras]

  # disable wait since secret may not exist yet and pods won't start until it does
  wait = false

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  name       = "xenit-proxy"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "8.8.1"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    thanos_receiver_fqdn = var.thanos_receiver_fqdn
    loki_api_fqdn        = var.loki_api_fqdn
  })]
}
