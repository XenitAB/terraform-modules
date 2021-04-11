/**
  * # Azure Key Vault Provider for Secrets Store CSI Driver
  *
  * Adds [csi-secrets-store-provider-azure](https://github.com/Azure/secrets-store-csi-driver-provider-azure) to a Kubernetes cluster.
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
      name = "csi-secrets-store-provider-azure"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "csi-secrets-store-provider-azure"
  }
}

resource "helm_release" "csi_secrets_store_provider_azure" {
  name       = "csi-secrets-store-provider-azure"
  repository = "https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts"
  chart      = "csi-secrets-store-provider-azure"
  version    = "0.0.18"
  namespace  = kubernetes_namespace.this.metadata[0].name

  set {
    name  = "linux.tolerations[0].operator"
    value = "Exists"
  }

  set {
    name  = "secrets-store-csi-driver.linux.metricsAddr"
    value = ":8081"
  }

  set {
    name  = "secrets-store-csi-driver.enableSecretRotation"
    value = true
  }

  set {
    name  = "secrets-store-csi-driver.linux.tolerations[0].operator"
    value = "Exists"
  }
}

resource "helm_release" "csi_secrets_store_provider_azure_extras" {
  depends_on = [helm_release.csi_secrets_store_provider_azure]

  chart     = "${path.module}/charts/csi-secrets-store-provider-azure-extras"
  name      = "csi-secrets-store-provider-azure-extras"
  namespace = kubernetes_namespace.this.metadata[0].name

  set {
    name  = "prometheusEnabled"
    value = var.prometheus_enabled
  }
}
