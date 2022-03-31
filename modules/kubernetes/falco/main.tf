/**
  * # Falco
  *
  * Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.
  * The modules consists of two components, the main Falco driver and Falco exporter
  * to expose event metrics.
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
      name                = "falco"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "falco"
  }
}

resource "helm_release" "falco" {
  repository  = "https://falcosecurity.github.io/charts"
  chart       = "falco"
  name        = "falco"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "1.17.4"
  max_history = 3
  values = [templatefile("${path.module}/templates/falco-values.yaml.tpl", {
    provider = var.cloud_provider
  })]
}

resource "helm_release" "falco_exporter" {
  repository  = "https://falcosecurity.github.io/charts"
  chart       = "falco-exporter"
  name        = "falco-exporter"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "0.8.0"
  max_history = 3
  values      = [templatefile("${path.module}/templates/falco-exporter-values.yaml.tpl", {})]
}
