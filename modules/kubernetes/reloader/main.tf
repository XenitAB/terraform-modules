/**
  * # Reloader
  *
  * Adds [`Reloader`](https://github.com/stakater/Reloader) to a Kubernetes clusters.
  *
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.3.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "reloader"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "reloader"
  }
}

resource "helm_release" "reloader" {
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  name       = "reloader"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v0.0.94"

  set {
    name  = "reloader.deployment.priorityClassName"
    value = "platform-low"
  }
}
