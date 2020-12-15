/**
  * # Certificate manager (cert-manager)
  *
  * This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

locals {
  namespace = "cert-manager"
  values    = templatefile("${path.module}/templates/values.yaml.tpl", {})
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = local.namespace
    }
    name = local.namespace
  }
}

resource "helm_release" "cert_manager" {
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  name       = "cert-manager"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v1.0.4"
  values     = [local.values]
}

resource "helm_release" "cert_manager_extras" {
  depends_on = [helm_release.cert_manager]

  chart     = "${path.module}/charts/cert-manager-extras"
  name      = "cert-manager-extras"
  namespace = kubernetes_namespace.this.metadata[0].name

  set {
    name  = "notificationEmail"
    value = var.notification_email
  }

  set {
    name  = "acmeServer"
    value = var.acme_server
  }

  set {
    name = "cloudProvider"
    value = var.cloudProvider
  }

  set {
    name = "azureConfig.resourceID"
    value = var.azure_config.resource_id
  }

  set {
    name = "azureConfig.clientID"
    value = var.azure_config.client_id
  }

  set {
    name = "azureConfig.subscriptionID"
    value = var.azure_config.subscription_id
  }

  set {
    name = "azureConfig.hostedZone"
    value = var.azure_config.hosted_zone
  }
}
