/**
  * # Nginx Gateway Fabric
  *
  * This module is used to add [`nginx-gateway-fabric`](https://docs.nginx.com/nginx-gateway-fabric/) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "kubernetes_namespace" "envoy_gateway" {
  metadata {
    name = "nginx-gateway"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/envoy-gateway.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "envoy_gateway" {
  path = "platform/${var.cluster_id}/envoy-gateway/envoy-gateway.yaml"
  content = templatefile("${path.module}/templates/envoy-gateway.yaml.tpl", {
    envoy_gateway_config = var.envoy_gateway_config
  })
}