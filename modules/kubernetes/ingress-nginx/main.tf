/**
  * # Ingress NGINX (ingress-nginx)
  *
  * This module is used to add [`ingress-nginx`](https://github.com/kubernetes/ingress-nginx) to Kubernetes clusters.
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
      name                = "ingress-nginx"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "3.29.0"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    http_snippet       = var.http_snippet,
    prometheus_enabled = var.prometheus_enabled,
  })]
}
