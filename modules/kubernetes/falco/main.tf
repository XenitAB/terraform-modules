/**
  * # Falco
  *
  * Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.
  * The modules consists of two components, the main Falco driver and Falco exporter
  * to expose event metrics.
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
  path = "clusters/${var.cluster_id}/falco.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "falco" {
  path = "platform/${var.cluster_id}/falco/falco.yaml"
  content = templatefile("${path.module}/templates/falco.yaml.tpl", {
  })
}

resource "git_repository_file" "falco_exporter" {
  path = "platform/${var.cluster_id}/falco/falco-exporter.yaml"
  content = templatefile("${path.module}/templates/falco-exporter.yaml.tpl", {
  })
}
