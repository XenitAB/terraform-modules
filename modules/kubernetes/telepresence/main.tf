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
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "telepresence" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/telepresence.yaml"
  content = templatefile("${path.module}/templates/telepresence.yaml.tpl", {
    telepresence_config = var.telepresence_config
    project             = var.fleet_infra_config.argocd_project_name
    server              = var.fleet_infra_config.k8s_api_server_url
  })
}
