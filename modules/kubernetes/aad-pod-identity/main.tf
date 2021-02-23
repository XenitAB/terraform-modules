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
      version = "2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}

locals {
  name      = "aad-pod-identity"
  namespace = "aad-pod-identity"
}

locals {
  values = templatefile("${path.module}/templates/values.yaml.tpl", { namespaces = var.namespaces, aad_pod_identity = var.aad_pod_identity })
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = local.namespace
    }
    name = local.namespace
  }
}

resource "helm_release" "aad_pod_identity" {
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = local.name
  name       = local.name
  version    = "2.1.0"
  namespace  = kubernetes_namespace.this.metadata[0].name
  values     = [local.values]
}
