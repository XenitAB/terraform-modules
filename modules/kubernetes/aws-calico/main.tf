/**
  * # AWS Calico (aws-calico)
  *
  * This module is used to add [`aws-calico`](https://github.com/aws/amazon-vpc-cni-k8s/tree/master/charts/aws-calico) to a Kubernetes cluster.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.3.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
  }
}

locals {
  namespace = "calico-system"
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

resource "helm_release" "calico" {
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-calico"
  name       = "aws-calico"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v0.3.4"
}
