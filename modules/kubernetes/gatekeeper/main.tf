/**
  * # Gatekeeper
  *
  * Adds [`gatekeeper`](https://github.com/open-policy-agent/gatekeeper) to a Kubernetes clusters.
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
  path = "clusters/${var.cluster_id}/gatekeeper.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "gatekeeper" {
  path = "platform/${var.cluster_id}/gatekeeper/gatekeeper.yaml"
  content = templatefile("${path.module}/templates/gatekeeper.yaml.tpl", {
    provider = var.cloud_provider
  })
}

resource "git_repository_file" "gatekeeper_template" {
  path    = "platform/${var.cluster_id}/gatekeeper-template/gatekeeper-template.yaml"
  content = templatefile("${path.module}/templates/gatekeeper-template.yaml.tpl", {})
}

resource "git_repository_file" "gatekeeper_config" {
  path = "platform/${var.cluster_id}/gatekeeper-config/gatekeeper-config.yaml"
  content = templatefile("${path.module}/templates/gatekeeper-config.yaml.tpl", {
    exclude_namespaces = var.exclude_namespaces
  })
}
