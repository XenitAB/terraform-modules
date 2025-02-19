/**
  * # Certificate manager (cert-manager)
  *
  * This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
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

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "git_repository_file" "kustomization" {
  depends_on = [kubernetes_namespace.cert_manager]

  path = "clusters/${var.cluster_id}/cert-manager.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id,
  })
}

resource "git_repository_file" "cert_manager" {
  depends_on = [kubernetes_namespace.cert_manager]

  path = "platform/${var.cluster_id}/cert-manager/cert-manager.yaml"
  content = templatefile("${path.module}/templates/cert-manager.yaml.tpl", {
    acme_server              = var.acme_server,
    client_id                = azurerm_user_assigned_identity.cert_manager.client_id,
    dns_zones                = var.dns_zones,
    notification_email       = var.notification_email,
    resource_group_name      = var.global_resource_group_name,
    subscription_id          = var.subscription_id,
    gateway_api_enabled      = var.gateway_api_enabled,
    gateway_solver_name      = var.gateway_api_config.gateway_name,
    gateway_solver_namespace = var.gateway_api_config.gateway_namespace,
  })
}
