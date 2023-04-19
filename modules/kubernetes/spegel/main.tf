/**
  * # Spegel
  *
  * This module is used to add [spegel](https://github.com/XenitAB/spegel) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = "spegel"
    labels = {
      name                = "spegel"
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "helm_release" "this" {
  chart       = "oci://ghcr.io/xenitab/helm-charts/spegel"
  name        = "spegel"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "v0.0.6"
  max_history = 3
  values      = [templatefile("${path.module}/templates/values.yaml.tpl", {})]
}
