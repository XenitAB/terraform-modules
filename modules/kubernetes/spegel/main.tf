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
      version = "0.0.2"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/spegel.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "spegel" {
  path = "platform/${var.cluster_id}/spegel/spegel.yaml"
  content = templatefile("${path.module}/templates/spegel.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}
