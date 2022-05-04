/**
  * # AWS Key Vault Provider for Secrets Store CSI Driver
  *
  * Adds [csi-secrets-store-provider-aws](https://github.com/aws/secrets-store-csi-driver-provider-aws) to a Kubernetes cluster.
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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
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

data "helm_template" "csi_secrets_store_driver" {
  repository   = "https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/master/charts"
  chart        = "secrets-store-csi-driver"
  name         = "secrets-store-csi-driver"
  version      = "0.2.0"
  include_crds = true
}

data "kubectl_file_documents" "csi_secrets_store_driver" {
  content = data.helm_template.csi_secrets_store_driver.manifest
}

resource "kubectl_manifest" "csi_secrets_store_driver" {
  for_each = {
    for k, v in data.kubectl_file_documents.csi_secrets_store_driver.manifests :
    k => v
    if can(regex("^/apis/apiextensions.k8s.io/v1/customresourcedefinitions/", k))
  }
  server_side_apply = true
  apply_only        = true
  yaml_body         = each.value
}

resource "helm_release" "csi_secrets_store_driver" {
  depends_on = [kubectl_manifest.csi_secrets_store_driver]

  repository  = "https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/master/charts"
  chart       = "secrets-store-csi-driver"
  name        = "secrets-store-csi-driver"
  version     = "0.2.0"
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
