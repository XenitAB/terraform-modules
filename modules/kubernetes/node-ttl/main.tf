/**
  * # Node TTL
  *
  * This module is used to add [`node-ttl`](https://github.com/XenitAB/node-ttl) to Kubernetes clusters.
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
      name                = "node-ttl"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "node-ttl"
  }
}

resource "helm_release" "this" {
  repository  = "oci://ghcr.io/xenitab/helm-charts/node-ttl"
  chart       = "node-ttl"
  name        = "node-ttl"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "0.0.3"
  max_history = 3
}
