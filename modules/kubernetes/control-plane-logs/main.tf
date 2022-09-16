/**
  * # Controle plan logs
  *
  * This module is used to run a small [vector](https://vector.dev/) deployment inside the cluster.
  * It listens to a message queue, parses the output and pushes it to stdout.
  *
  * vector.toml includes the config how to connect to it's different endpoints.
  * Vector supports unit testing, and to verfiy it's config you can run `vector test vector.toml`.
  *
  * If you need to update the vector.toml you need to perform the following
  * manuall task to regenerate the secret located in the templates file
  * cat vector.toml |base64 -w 0
  * All the variabels in vector.toml is read in through environment variabels in the deployment.
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
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    cloud_provider = var.cloud_provider
    azure_config   = var.azure_config
  })]
}
