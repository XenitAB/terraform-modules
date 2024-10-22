/**
  * # Contour
  *
  * This module is used to add [`Contour`](https://projectcontour.io/) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

resource "kubernetes_namespace" "contour" {
  metadata {
    name = "projectcontour"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/contour.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "contour" {
  path = "platform/${var.cluster_id}/contour/contour.yaml"
  content = templatefile("${path.module}/templates/contour.yaml.tpl")
  
  /*, {
    contour_config = var.contour_config
    envoy_config   = var.envoy_config
    hpa_config     = var.envoy_config.hpa_config
  })
*/
}
