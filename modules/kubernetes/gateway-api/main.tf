/**
  * # Gateway API
  *
  * This module is used to add [`gateway-api`](https://github.com/kubernetes-sigs/gateway-api) CRDs from the experimental channel to Kubernetes clusters.
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

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/gateway-api.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id  = var.cluster_id
    api_version = var.gateway_api_config.api_version
    api_channel = var.gateway_api_config.api_channel
  })
}