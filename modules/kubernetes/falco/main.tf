/**
  * # Falco
  *
  * Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.
  * The modules consists of two components, the main Falco driver and the sidekick which
  * exports events to Datadog.
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
      name = "falco"
    }
    name = "falco"
  }
}

resource "helm_release" "falco" {
  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco"
  name       = "falco"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v1.7.1"
}
