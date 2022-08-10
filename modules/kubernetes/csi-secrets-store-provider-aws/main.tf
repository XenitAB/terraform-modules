/**
  * # AWS Key Vault Provider for Secrets Store CSI Driver
  *
  * Adds [csi-secrets-store-provider-aws](https://github.com/aws/secrets-store-csi-driver-provider-aws) to a Kubernetes cluster.
  */

terraform {
  required_version = ">= 1.2.6"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "csi-secrets-store-provider-aws"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "csi-secrets-store-provider-aws"
  }
}

resource "helm_release" "csi_secrets_store_driver" {
  repository  = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart       = "secrets-store-csi-driver"
  name        = "secrets-store-csi-driver"
  version     = "1.1.2"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  skip_crds   = true

  set {
    name  = "linux.metricsAddr"
    value = ":8081"
  }

  set {
    name  = "enableSecretRotation"
    value = true
  }

  set {
    name  = "linux.tolerations[0].operator"
    value = "Exists"
  }

  set {
    name  = "linux.priorityClassName"
    value = "platform-high"
  }

  set {
    name  = "syncSecret.enabled"
    value = "true"
  }
}

resource "helm_release" "csi_secrets_store_provider_aws" {
  depends_on = [helm_release.csi_secrets_store_driver]

  chart       = "${path.module}/charts/csi-secrets-store-provider-aws"
  name        = "csi-secrets-store-provider-aws"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
}
