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
  path = "platform/${var.tenants_name}/${var.cluster_id}/argocd-applications/reloader.yaml"
  content = templatefile("${path.module}/templates/reloader.yaml.tpl", {
  })
}
