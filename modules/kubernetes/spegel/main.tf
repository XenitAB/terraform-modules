/**
  * # Spegel
  *
  * This module is used to add [spegel](https://github.com/XenitAB/spegel) to Kubernetes clusters.
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

resource "git_repository_file" "spegel" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/spegel.yaml"
  content = templatefile("${path.module}/templates/spegel.yaml.tpl", {
    private_registry = var.private_registry
    tenant_name      = var.tenant_name
    environment      = var.environment
    project          = var.fleet_infra_config.argocd_project_name
    server           = var.fleet_infra_config.k8s_api_server_url
  })
}
