/**
  * # Vertical Pod Autoscaler/
  *
  * Adds [`VPA`](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) using
  * [`FairwindsOps`](https://github.com/FairwindsOps/charts/tree/master/stable/vpa) helm chart to deploy VPA.
  * VPA recommender is the only feature enabled, it's not possible to auto update deployments from VPA.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
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
  values      = [templatefile("${path.module}/templates/vpa-values.yaml.tpl", {})]
}
