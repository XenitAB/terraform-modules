/**
  * # Controle plan logs
  *
  * This module is used to run a small [vector](https://vector.dev/) deployment inside the cluster.
  * It listens to a message queue, parses the output and pushes it to stdout.
  */

terraform {
  required_version = ">= 1.2.6"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = "controle-plane-logs"
    labels = {
      name                = "controle-plane-logs"
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "helm_release" "vector" {
  chart       = "${path.module}/charts/vector"
  name        = "vector"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  values = [templatefile("${path.module}/templates/values-extras.yaml.tpl", {
    cloud_provider = var.cloud_provider
    azure_config   = var.azure_config
  })]
}
