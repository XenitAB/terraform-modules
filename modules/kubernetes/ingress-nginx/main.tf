/**
  * # Ingress NGINX (ingress-nginx)
  *
  * This module is used to add [`ingress-nginx`](https://github.com/kubernetes/ingress-nginx) to Kubernetes clusters.
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
      version = "2.2.0"
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
  version    = "3.35.0"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    http_snippet           = var.http_snippet
    name_override          = var.name_override
    provider               = var.cloud_provider
    ingress_class          = join("-", compact(["nginx", var.name_override]))
    internal_load_balancer = var.internal_load_balancer
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    extra_config          = var.extra_config
    extra_headers         = var.extra_headers
    linkerd_enabled       = var.linkerd_enabled
    multiple_ingress      = var.multiple_ingress
    default_ingress_class = var.default_ingress_class
  })]
}

resource "helm_release" "ingress_nginx_extras" {
  chart     = "${path.module}/charts/ingress-nginx-extras"
  name      = "ingress-nginx-extras"
  namespace = kubernetes_namespace.this.metadata[0].name

  set {
    name  = "defaultCertificate.enabled"
    value = var.default_certificate.enabled
  }

  set {
    name  = "defaultCertificate.dnsZone"
    value = var.default_certificate.dns_zone
  }
}