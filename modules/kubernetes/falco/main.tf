/**
  * # Falco
  *
  * Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.
  * The modules consists of two components, the main Falco driver and Falco exporter
  * to expose event metrics.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.4.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
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
  version    = "1.15.7"
  values     = [templatefile("${path.module}/templates/falco-values.yaml.tpl", {})]
}

resource "helm_release" "falco_exporter" {
  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco-exporter"
  name       = "falco-exporter"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "0.5.2"
  values     = [templatefile("${path.module}/templates/falco-exporter-values.yaml.tpl", {})]
}
