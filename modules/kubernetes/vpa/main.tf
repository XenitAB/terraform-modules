/**
  * # Vertical Pod Autoscaler/
  *
  * Adds [`VPA`](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) using
  * [`FairwindsOps`](https://github.com/FairwindsOps/charts/tree/master/stable/vpa) helm chart to deploy VPA.
  * VPA recommender is the only feature enabled, it's not possible to auto update deployments from VPA.
  * [`Goldilocks`](https://github.com/FairwindsOps/charts/tree/master/stable/goldilocks) is used to auto create
  * VPA config to all kinds of workloads. This will help us generate metrics for our tenants and the platform.
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
  path = "clusters/${var.cluster_id}/vpa.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "vpa" {
  path    = "platform/${var.cluster_id}/vpa/vpa.yaml"
  content = templatefile("${path.module}/templates/vpa.yaml.tpl", {})
}
