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
      version = ">=0.0.4"
    }
  }
}

resource "git_repository_file" "node_ttl" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/node-ttl.yaml"
  content = templatefile("${path.module}/templates/node-ttl.yaml.tpl", {
    status_config_map_namespace = var.status_config_map_namespace
    tenant_name                 = var.tenant_name
    environment                 = var.environment
    project                     = var.fleet_infra_config.argocd_project_name
    server                      = var.fleet_infra_config.k8s_api_server_url
  })
}
