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

locals {
  falco_values = templatefile("${path.module}/templates/falco-values.yaml.tpl", {})
  falcosidekick_values = templatefile("${path.module}/templates/falcosidekick-values.yaml.tpl", {
    environment      = var.environment
    minimum_priority = var.minimum_priority
    datadog_host     = "https://${var.datadog_site}"
    datadog_api_key  = var.datadog_api_key
  })
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
  version    = "v1.7.2"
  values     = [local.falco_values]
}

resource "helm_release" "falcosidekick" {
  repository = "https://falcosecurity.github.io/charts"
  chart      = "falcosidekick"
  name       = "falcosidekick"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v0.2.4"
  values     = [local.falcosidekick_values]
}
