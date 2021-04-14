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
  required_version = "0.14.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.0"
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
