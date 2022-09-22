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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

resource "kubernetes_namespace" "vpa" {
  metadata {
    labels = {
      name                = "vpa"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "vpa"
  }
}

resource "helm_release" "vpa" {
  repository  = "https://charts.fairwinds.com/stable"
  chart       = "vpa"
  name        = "vpa"
  namespace   = kubernetes_namespace.vpa.metadata[0].name
  version     = "0.5.0"
  max_history = 3
  skip_crds   = true
  values      = [templatefile("${path.module}/templates/vpa-values.yaml.tpl", {})]
}

resource "helm_release" "goldilocks" {
  repository  = "https://charts.fairwinds.com/stable"
  chart       = "goldilocks"
  name        = "goldilocks"
  namespace   = kubernetes_namespace.vpa.metadata[0].name
  version     = "5.1.0"
  max_history = 3
  values      = [templatefile("${path.module}/templates/goldilocks-values.yaml.tpl", {})]
}
