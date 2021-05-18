/**
  * # Xenit Platform Configuration
  *
  * This module is used to add Xenit Kubernetes Framework configuration to Kubernetes clusters.
  *
  * You need to configure a certificate in Azure KeyVault
  * ```shell
  * openssl pkcs12 -export -in tenant-xenit-proxy.crt -inkey tenant-xenit-proxy.key -out tenant-xenit-proxy.pfx
  * az keyvault certificate import --vault-name <aks keyvault name> -n xenit-proxy-certificate -f tenant-xenit-proxy.pfx
  * ```
  *
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.2"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "xenit-system"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "xenit-system"
  }
}

resource "helm_release" "xenit_proxy_extras" {
  chart     = "${path.module}/charts/xenit-proxy-extras"
  name      = "xenit-proxy-extras"
  namespace = kubernetes_namespace.this.metadata[0].name

  set {
    name  = "resourceID"
    value = var.azure_config.identity.resource_id
  }

  set {
    name  = "clientID"
    value = var.azure_config.identity.client_id
  }

  set {
    name  = "tenantID"
    value = var.azure_config.identity.tenant_id
  }

  set {
    name  = "keyVaultName"
    value = var.azure_config.azure_key_vault_name
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
  version    = "8.9.0"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    thanos_receiver_fqdn = var.thanos_receiver_fqdn
    loki_api_fqdn        = var.loki_api_fqdn
  })]
}
