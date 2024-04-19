/**
  * # Velero
  *
  * This module is used to add [`velero`](https://github.com/vmware-tanzu/velero) to Kubernetes clusters.
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
  path = "clusters/${var.cluster_id}/velero.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "velero" {
  path = "platform/${var.cluster_id}/velero/velero.yaml"
  content = templatefile("${path.module}/templates/velero.yaml.tpl", {
    azure_config = var.azure_config,
  })
}

resource "git_repository_file" "velero_extras" {
  path = "platform/${var.cluster_id}/velero/velero-extras.yaml"
  content = templatefile("${path.module}/templates/velero-extras.yaml.tpl", {
    client_id   = var.azure_config.client_id,
    resource_id = var.azure_config.resource_id,
  })
}
