/**
  * # Ingress NGINX (ingress-nginx)
  *
  * This module is used to add [`ingress-nginx`](https://github.com/kubernetes/ingress-nginx) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
    labels = {
      "xkf.xenit.io/kind" = "platform"
      "name"              = "ingress-nginx"
    }
  }
}

resource "git_repository_file" "kustomization" {
  depends_on = [kubernetes_namespace.ingress_nginx]

  path = "clusters/${var.cluster_id}/ingress-nginx.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "ingress_nginx" {
  depends_on = [kubernetes_namespace.ingress_nginx]

  path = "platform/${var.cluster_id}/ingress-nginx/ingress-nginx.yaml"
  content = templatefile("${path.module}/templates/ingress-nginx.yaml.tpl", {
    ingress_class          = "nginx"
    ingress_nginx_name     = "ingress-nginx"
    default_ingress_class  = true
    internal_load_balancer = false
    external_dns_hostname  = var.external_dns_hostname
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    private_ingress_enabled   = var.private_ingress_enabled
    allow_snippet_annotations = var.customization.allow_snippet_annotations
    http_snippet              = var.customization.http_snippet
    extra_config              = var.customization.extra_config
    extra_headers             = var.customization.extra_headers
    linkerd_enabled           = var.linkerd_enabled
    datadog_enabled           = var.datadog_enabled
  })
}

resource "git_repository_file" "ingress_nginx_private" {
  depends_on = [kubernetes_namespace.ingress_nginx]
  for_each = {
    for s in ["ingress-nginx-private"] :
    s => s
    if var.private_ingress_enabled
  }

  path = "platform/${var.cluster_id}/ingress-nginx/ingress-nginx-private.yaml"
  content = templatefile("${path.module}/templates/ingress-nginx.yaml.tpl", {
    ingress_class          = "nginx-private"
    ingress_nginx_name     = "ingress-nginx-private"
    default_ingress_class  = false
    internal_load_balancer = true
    external_dns_hostname  = var.external_dns_hostname
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    private_ingress_enabled   = var.private_ingress_enabled
    allow_snippet_annotations = var.customization_private.allow_snippet_annotations == null ? var.customization.allow_snippet_annotations : var.customization_private.allow_snippet_annotations
    http_snippet              = var.customization_private.http_snippet == null ? var.customization.http_snippet : var.customization_private.http_snippet
    extra_config              = merge(var.customization.extra_config, var.customization_private.extra_config)
    extra_headers             = merge(var.customization.extra_headers, var.customization_private.extra_config)
    linkerd_enabled           = var.linkerd_enabled
    datadog_enabled           = var.datadog_enabled
  })
}
