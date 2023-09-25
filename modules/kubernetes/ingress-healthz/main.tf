/**
  * # Ingress Healthz (ingress-healthz)
  *
  * This module is used to deploy a very simple NGINX server meant to check the health of cluster ingress.
  * It is meant to simulate an application that expects traffic through the ingress controller with
  * automatic DNS creation and certificate creation, without depending on the stability of a dynamic application.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

locals {
  ingress_class_name = var.public_private_enabled == true ? "nginx-public" : "nginx"
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/ingress-healthz.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "ingress_healthz" {
  path = "platform/${var.cluster_id}/ingress-healthz/ingress-healthz.yaml"
  content = templatefile("${path.module}/templates/ingress-healthz.yaml.tpl", {
    environment        = var.environment
    dns_zone           = var.dns_zone
    location_short     = var.location_short
    linkerd_enabled    = var.linkerd_enabled
    ingress_class_name = local.ingress_class_name
  })
}
