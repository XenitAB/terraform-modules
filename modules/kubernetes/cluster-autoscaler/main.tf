/**
  * # Cluster Autoscaler (cluster-autoscaler)
  *
  * This module is used to add [`cluster-autoscaler`](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.2.6"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

locals {
  tags = {
    "1.22" = "1.22.3"
    "1.23" = "1.23.1"
    "1.24" = "1.24.0"
  }
}

data "kubectl_server_version" "current" {}

resource "kubernetes_namespace" "this" {
  metadata {
    name = "cluster-autoscaler"
    labels = {
      name                = "cluster-autoscaler"
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "helm_release" "cluster_autoscaler" {
  repository  = "https://kubernetes.github.io/autoscaler"
  chart       = "cluster-autoscaler"
  name        = "cluster-autoscaler"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "9.19.2"
  max_history = 3
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    provider     = var.cloud_provider,
    cluster_name = var.cluster_name
    aws_config   = var.aws_config
    tag          = local.tags["${data.kubectl_server_version.current.major}.${data.kubectl_server_version.current.minor}"]
  })]
}
