/**
  * # Certificate manager (cert-manager)
  *
  * This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
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
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  name       = "cert-manager"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v1.5.3"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    provider   = var.cloud_provider,
    aws_config = var.aws_config,
  })]
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
    name  = "cloudProvider"
    value = var.cloud_provider
  }

  set {
    name  = "azureConfig.resourceGroupName"
    value = var.azure_config.resource_group_name
  }

  set {
    name  = "azureConfig.clientID"
    value = var.azure_config.client_id
  }

  set {
    name  = "azureConfig.subscriptionID"
    value = var.azure_config.subscription_id
  }

  set {
    name  = "azureConfig.resourceID"
    value = var.azure_config.resource_id
  }

  set {
    name  = "azureConfig.hostedZoneName"
    value = var.azure_config.hosted_zone_name
  }

  set {
    name  = "awsConfig.region"
    value = var.aws_config.region
  }

  set {
    name  = "awsConfig.hostedZoneID"
    value = var.aws_config.hosted_zone_id
  }
}
