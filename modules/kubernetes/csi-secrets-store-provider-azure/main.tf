/**
  * # Azure Key Vault Provider for Secrets Store CSI Driver
  *
  * Adds [csi-secrets-store-provider-azure](https://github.com/Azure/secrets-store-csi-driver-provider-azure) to a Kubernetes cluster.
  */

terraform {
  required_version = ">= 1.1.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "csi-secrets-store-provider-azure"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "csi-secrets-store-provider-azure"
  }
}

resource "helm_release" "csi_secrets_store_provider_azure" {
  repository  = "https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts"
  version     = "0.2.1"
  chart       = "csi-secrets-store-provider-azure"
  name        = "csi-secrets-store-provider-azure"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  skip_crds   = true
  values      = [templatefile("${path.module}/templates/values.yaml.tpl", {})]
}
