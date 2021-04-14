/**
  * # Xenit Platform Configuration
  *
  * This module is used to add Xenit Kubernetes Framework configuration to Kubernetes clusters.
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "xenit-system"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "xenit-system"
  }
}
