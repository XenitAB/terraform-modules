/**
  * # Node TTL
  *
  * This module is used to add [`node-ttl`](https://github.com/XenitAB/node-ttl) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.2"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/node-ttl.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "node_ttl" {
  path = "platform/${var.cluster_id}/node-ttl/node-ttl.yaml"
  content = templatefile("${path.module}/templates/node-ttl.yaml.tpl", {
    status_config_map_namespace = var.status_config_map_namespace
  })
}
