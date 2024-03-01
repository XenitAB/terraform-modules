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

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/telepresence.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "telepresence" {
  path = "platform/${var.cluster_id}/telepresence/telepresence.yaml"
  content = templatefile("${path.module}/templates/telepresence.yaml.tpl", {
    telepresence_config = var.telepresence_config
  })
}
