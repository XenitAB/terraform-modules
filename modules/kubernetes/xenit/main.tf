/**
  * # Xenit Platform Configuration
  *
  * WARNING. This module is currently not used due to observations of SNAT port exhaustion occuring.
  * The proxy should not be used until these issues have been resolved.
  * https://www.danielstechblog.io/detecting-snat-port-exhaustion-on-azure-kubernetes-service/
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
      version = "2.6.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
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
    name  = "cloudProvider"
    value = var.cloud_provider
  }

  set {
    name  = "azureConfig.resourceID"
    value = var.azure_config.identity.resource_id
  }

  set {
    name  = "azureConfig.clientID"
    value = var.azure_config.identity.client_id
  }

  set {
    name  = "azureConfig.tenantID"
    value = var.azure_config.identity.tenant_id
  }

  set {
    name  = "azureConfig.keyVaultName"
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
  version    = "9.5.10"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    cloud_provider       = var.cloud_provider
    aws_config           = var.aws_config
    thanos_receiver_fqdn = var.thanos_receiver_fqdn
    loki_api_fqdn        = var.loki_api_fqdn
  })]
}
