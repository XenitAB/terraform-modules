/**
  * # Certificate manager (cert-manager)
  *
  * This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.1.7"

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

locals {
  namespace = "cert-manager"
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = local.namespace
      "xkf.xenit.io/kind" = "platform"
    }
    name = local.namespace
  }
}

resource "helm_release" "cert_manager" {
  repository  = "https://charts.jetstack.io"
  chart       = "cert-manager"
  name        = "cert-manager"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "v1.7.1"
  max_history = 3
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    provider = var.cloud_provider,
  })]
}

resource "helm_release" "cert_manager_extras" {
  depends_on = [helm_release.cert_manager]

  chart       = "${path.module}/charts/cert-manager-extras"
  name        = "cert-manager-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3

  set {
    name  = "notificationEmail"
    value = var.notification_email
  }

  set {
    name  = "acmeServer"
    value = var.acme_server
  }
  set {
    name  = "acmeServer"
    value = var.ingress_public_private_enabled
  }
}
