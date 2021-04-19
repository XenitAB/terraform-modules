/**
  * # Ingress Healthz (ingress-healthz)
  *
  * This module is used to deploy a very simple NGINX server meant to check the health of cluster ingress.
  * It is meant to simulate an application that expects traffic through the ingress controller with
  * automatic DNS creation and certificate creation, without depending on the stability of a dynamic application.
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
      name                = "ingress-healthz"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "ingress-healthz"
  }
}

resource "helm_release" "ingress_healthz" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  name       = "ingress-healthz"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "8.8.3"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    environment = var.environment
    dns_zone    = var.dns_zone
  })]
}
