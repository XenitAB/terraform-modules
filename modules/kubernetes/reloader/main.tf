/**
  * # Reloader
  *
  * Adds [`Reloader`](https://github.com/stakater/Reloader) to a Kubernetes clusters.
  * 
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = "reloader"
    }
    name = "reloader"
  }
}

resource "helm_release" "reloader" {
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  name       = "reloader"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v0.0.80"
}
