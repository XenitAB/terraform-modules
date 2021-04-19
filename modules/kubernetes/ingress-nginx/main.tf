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
      name                = join("-", compact(["ingress-nginx", var.name_override]))
      "xkf.xenit.io/kind" = "platform"
    }
    name = join("-", compact(["ingress-nginx", var.name_override]))
  }
}

resource "helm_release" "ingress_nginx" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "3.29.0"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    http_snippet           = var.http_snippet,
    name_override          = var.name_override,
    provider               = var.cloud_provider,
    ingress_class          = join("-", compact(["nginx", var.name_override])),
    internal_load_balancer = var.internal_load_balancer,
  })]
}
