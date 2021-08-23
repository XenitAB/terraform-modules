/**
  * # Cluster Autoscaler (cluster-autoscaler)
  *
  * This module is used to add [`cluster-autoscaler`](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler) to Kubernetes clusters.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.4.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
  }
}

locals {
  namespace = "cluster-autoscaler"
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = local.namespace
      "xkf.xenit.io/kind" = "platform"
    }
    name = local.namespace
  }
}

resource "helm_release" "cluster_autoscaler" {
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  name       = "cluster-autoscaler"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "9.10.4"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    provider     = var.cloud_provider,
    cluster_name = var.cluster_name
    aws_config   = var.aws_config
  })]
}
