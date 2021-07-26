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
    http_snippet           = var.http_snippet,
    name_override          = var.name_override,
    provider               = var.cloud_provider,
    ingress_class          = join("-", compact(["nginx", var.name_override])),
    internal_load_balancer = var.internal_load_balancer,
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    extra_config    = var.extra_config
    extra_headers   = var.extra_headers
    linkerd_enabled = var.linkerd_enabled
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

/* If the svc isn't created nginx creates error logs
* https://github.com/kubernetes/ingress-nginx/issues/2599
* https://github.com/kubernetes/ingress-nginx/issues/2599
*/
resource "kubernetes_service" "private" {
  for_each = {
    for s in ["ingress-svc"] :
    s => s
    if var.internal_load_balancer && var.cloud_provider == "aws"
  }

  depends_on = [
    kubernetes_namespace.this
  ]

  wait_for_load_balancer = false
  metadata {
    name      = "ingress-nginx-${var.name_override}-controller"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    selector = {
      "app.kubernetes.io/name"      = var.name_override
      "app.kubernetes.io/instance"  = "ingress-nginx"
      "app.kubernetes.io/component" = "controller"
    }
    port {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = "http"
    }
    port {
      name        = "https"
      port        = 443
      protocol    = "TCP"
      target_port = "https"
    }

    type = "ClusterIP"
  }
}
