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
      version = "2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}

locals {
  namespace          = "csi-secrets-store-provider-azure"
  chart_release_name = "csi-secrets-store-provider-azure"
  chart_repository   = "https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts"
  chart_name         = "csi-secrets-store-provider-azure"
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = local.namespace
    }
    name = local.namespace
  }
}

resource "helm_release" "csi_secrets_store_provider_azure" {
  name       = local.chart_release_name
  repository = local.chart_repository
  chart      = local.chart_name
  version    = "0.0.16"
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
