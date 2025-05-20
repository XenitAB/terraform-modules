/**
  * # Telepresence
  *
  * Adds [`Telepresence`](https://github.com/telepresenceio/telepresence) to a Kubernetes cluster.
  *
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

resource "git_repository_file" "telepresence" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/telepresence.yaml"
  content = templatefile("${path.module}/templates/telepresence.yaml.tpl", {
    telepresence_config = var.telepresence_config
    tenant_name         = var.tenant_name
    environment         = var.environment
    project             = var.fleet_infra_config.argocd_project_name
    server              = var.fleet_infra_config.k8s_api_server_url
  })
}
