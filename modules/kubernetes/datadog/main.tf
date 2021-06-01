/**
  * # Datadog
  *
  * Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.
  * This module is built to only gather application data
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.3.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.2"
    }
  }
}

locals {
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    datadog_site      = var.datadog_site
    api_key           = var.api_key
    location          = var.location
    environment       = var.environment
    container_include = var.container_include
  })
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "datadog"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "datadog"
  }
}

resource "helm_release" "datadog" {
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  name       = "datadog"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "2.16.3"
  values     = [local.values]
}
