/**
  * # kube2iam
  *
  * Adds [`kube2iam`](https://github.com/jtblin/kube2iam/) to a Kubernetes clusters.
  *
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

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "kube2iam"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "kube2iam"
  }
}

resource "helm_release" "reloader" {
  repository = "https://jtblin.github.io/kube2iam/"
  chart      = "kube2iam"
  name       = "kube2iam"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "2.6.0"
  values     = [templatefile("${path.module}/templates/values.yaml.tpl", {})]
}
