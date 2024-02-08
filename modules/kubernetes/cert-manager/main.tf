/**
  * # Certificate manager (cert-manager)
  *
  * This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.
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
  azure_hosted_zone_names = "[${join(",", var.azure_config.hosted_zone_names)}]"
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/cert-manager.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}
resource "git_repository_file" "cert_manager" {
  path = "platform/${var.cluster_id}/cert-manager/cert-manager.yaml"
  content = templatefile("${path.module}/templates/cert-manager.yaml.tpl", {
    notification_email = var.notification_email,
    acme_server        = var.acme_server,
    azure_config       = var.azure_config,
    dns_zones          = local.azure_hosted_zone_names
  })

}
