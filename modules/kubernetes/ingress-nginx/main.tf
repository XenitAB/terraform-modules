/**
  * # Ingress NGINX (ingress-nginx)
  *
  * This module is used to add [`ingress-nginx`](https://github.com/kubernetes/ingress-nginx) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
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
  version     = "4.4.0"
  max_history = 3
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    provider               = var.cloud_provider
    ingress_class          = "nginx"
    default_ingress_class  = true
    internal_load_balancer = false
    external_dns_hostname  = var.external_dns_hostname
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    public_private_enabled    = var.public_private_enabled
    allow_snippet_annotations = var.customization.allow_snippet_annotations
    http_snippet              = var.customization.http_snippet
    extra_config              = var.customization.extra_config
    extra_headers             = var.customization.extra_headers
    linkerd_enabled           = var.linkerd_enabled
    datadog_enabled           = var.datadog_enabled
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
  version     = "4.4.0"
  max_history = 3
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    provider               = var.cloud_provider
    ingress_class          = "nginx-public"
    default_ingress_class  = true
    internal_load_balancer = false
    external_dns_hostname  = var.external_dns_hostname
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    public_private_enabled    = var.public_private_enabled
    allow_snippet_annotations = var.customization_public.allow_snippet_annotations == null ? var.customization.allow_snippet_annotations : var.customization_public.allow_snippet_annotations
    http_snippet              = var.customization_public.http_snippet == null ? var.customization.http_snippet : var.customization_public.http_snippet
    extra_config              = merge(var.customization.extra_config, var.customization_public.extra_config)
    extra_headers             = merge(var.customization.extra_headers, var.customization_public.extra_config)
    linkerd_enabled           = var.linkerd_enabled
    datadog_enabled           = var.datadog_enabled
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
  version     = "4.4.0"
  max_history = 3
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    provider               = var.cloud_provider
    ingress_class          = "nginx-private"
    default_ingress_class  = false
    internal_load_balancer = true
    external_dns_hostname  = var.external_dns_hostname
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    public_private_enabled    = var.public_private_enabled
    allow_snippet_annotations = var.customization_private.allow_snippet_annotations == null ? var.customization.allow_snippet_annotations : var.customization_private.allow_snippet_annotations
    http_snippet              = var.customization_private.http_snippet == null ? var.customization.http_snippet : var.customization_private.http_snippet
    extra_config              = merge(var.customization.extra_config, var.customization_private.extra_config)
    extra_headers             = merge(var.customization.extra_headers, var.customization_private.extra_config)
    linkerd_enabled           = var.linkerd_enabled
    datadog_enabled           = var.datadog_enabled
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
