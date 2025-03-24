/**
  * # Reloader
  *
  * Adds [`Reloader`](https://github.com/stakater/Reloader) to a Kubernetes clusters.
  *
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

resource "git_repository_file" "reloader" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/reloader.yaml"
  content = templatefile("${path.module}/templates/reloader.yaml.tpl", {
    project = var.fleet_infra_config.argocd_project_name
    server  = var.fleet_infra_config.k8s_api_server_url
  })
}
