/**
  * # Nginx Gateway Fabric
  *
  * This module is used to add [`nginx-gateway-fabric`](https://docs.nginx.com/nginx-gateway-fabric/) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "kubernetes_namespace" "nginx_gateway" {
  metadata {
    name = "nginx-gateway"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/nginx-gateway-fabric.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "ingress_nginx" {
  path = "platform/${var.cluster_id}/nginx-gateway-fabric/gateway-fabric.yaml"
  content = templatefile("${path.module}/templates/gateway-fabric.yaml.tpl", {
  })
}