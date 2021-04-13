/**
  * # Azure AD POD Identity (AAD-POD-Identity)
  *
  * This module is used to add [`aad-pod-identity`](https://github.com/Azure/aad-pod-identity) to Kubernetes clusters (tested with AKS).
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

locals {
  values = templatefile("${path.module}/templates/values.yaml.tpl", { namespaces = var.namespaces, aad_pod_identity = var.aad_pod_identity })
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "aad-pod-identity"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "aad-pod-identity"
  }
}

resource "helm_release" "aad_pod_identity" {
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = "aad-pod-identity"
  name       = "aad-pod-identity"
  version    = "4.0.0"
  namespace  = kubernetes_namespace.this.metadata[0].name
  values     = [local.values]
}

resource "helm_release" "aad_pod_identity_extras" {
  depends_on = [helm_release.aad_pod_identity]

  chart     = "${path.module}/charts/aad-pod-identity-extras"
  name      = "aad-pod-identity-extras"
  namespace = kubernetes_namespace.this.metadata[0].name
  disable_openapi_validation = true

  set {
    name  = "prometheusEnabled"
    value = var.prometheus_enabled
  }
}
