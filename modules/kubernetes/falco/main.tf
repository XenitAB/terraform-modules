/**
  * # Falco
  *
  * Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.
  * The modules consists of two components, the main Falco driver and Falco exporter
  * to expose event metrics.
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.1"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "falco"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "falco"
  }
}

resource "helm_release" "falco" {
  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco"
  name       = "falco"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "1.10.0"
  values     = [templatefile("${path.module}/templates/falco-values.yaml.tpl", {})]
}

resource "helm_release" "falco-exporter" {
  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco-exporter"
  name       = "falco-exporter"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "0.5.1"
}
