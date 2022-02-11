/**
  * # node local DNS
  *
  * This module is used to add [`node-local-dns`](https://kubernetes.io/docs/tasks/administer-cluster/nodelocaldns/) to Kubernetes clusters.
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

data "kubernetes_namespace" "this" {
  metadata {
    name = "kube-system"
  }
}

data "kubernetes_service" "this" {
  metadata {
    name      = "kube-dns"
    namespace = data.kubernetes_namespace.this.metadata[0].name
  }
}

resource "helm_release" "this" {
  chart       = "${path.module}/charts/node-local-dns"
  name        = "node-local-dns"
  namespace   = data.kubernetes_namespace.this.metadata[0].name
  max_history = 3

  set {
    name  = "dnsServer"
    value = data.kubernetes_service.this.spec.cluster_ip
  }
}
