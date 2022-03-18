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
      name                = "ingress-nginx"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  for_each = {
    for s in ["ingress-nginx"] :
    s => s
    if var.public_private_enabled == false
  }

  repository  = "https://kubernetes.github.io/ingress-nginx"
  chart       = "ingress-nginx"
  name        = "ingress-nginx"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "4.0.17"
  max_history = 3
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    http_snippet           = var.http_snippet
    provider               = var.cloud_provider
    ingress_class          = "nginx"
    internal_load_balancer = false
    public_private_enabled = var.public_private_enabled
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    extra_config              = var.extra_config
    extra_headers             = var.extra_headers
    linkerd_enabled           = var.linkerd_enabled
    datadog_enabled           = var.datadog_enabled
    allow_snippet_annotations = var.allow_snippet_annotations
    default_ingress_class     = true
  })]
}

resource "helm_release" "ingress_nginx_public" {
  for_each = {
    for s in ["ingress-nginx-public"] :
    s => s
    if var.public_private_enabled
  }

  repository  = "https://kubernetes.github.io/ingress-nginx"
  chart       = "ingress-nginx"
  name        = "ingress-nginx-public"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "4.0.17"
  max_history = 3
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    http_snippet           = var.http_snippet
    provider               = var.cloud_provider
    ingress_class          = "nginx-public"
    internal_load_balancer = false
    public_private_enabled = var.public_private_enabled
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    extra_config              = var.extra_config
    extra_headers             = var.extra_headers
    linkerd_enabled           = var.linkerd_enabled
    datadog_enabled           = var.datadog_enabled
    allow_snippet_annotations = var.allow_snippet_annotations
    default_ingress_class     = true
  })]
}

resource "helm_release" "ingress_nginx_private" {
  for_each = {
    for s in ["ingress-nginx-private"] :
    s => s
    if var.public_private_enabled
  }

  repository  = "https://kubernetes.github.io/ingress-nginx"
  chart       = "ingress-nginx"
  name        = "ingress-nginx-private"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "4.0.17"
  max_history = 3
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    http_snippet           = var.http_snippet
    provider               = var.cloud_provider
    ingress_class          = "nginx-private"
    internal_load_balancer = true
    public_private_enabled = var.public_private_enabled
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    extra_config              = var.extra_config
    extra_headers             = var.extra_headers
    linkerd_enabled           = var.linkerd_enabled
    datadog_enabled           = var.datadog_enabled
    allow_snippet_annotations = var.allow_snippet_annotations
    default_ingress_class     = false
  })]
}

resource "helm_release" "ingress_nginx_extras" {
  chart       = "${path.module}/charts/ingress-nginx-extras"
  name        = "ingress-nginx-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3

  set {
    name  = "defaultCertificate.enabled"
    value = var.default_certificate.enabled
  }

  set {
    name  = "defaultCertificate.dnsZone"
    value = var.default_certificate.dns_zone
  }
}
