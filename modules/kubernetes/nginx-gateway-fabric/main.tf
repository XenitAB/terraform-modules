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
    logging_level             = var.gateway_config.logging_level
    replica_count             = var.gateway_config.replica_count
    telemetry_enabled         = var.gateway_config.telemetry_enabled
    telemetry_config          = var.gateway_config.telemetry_config
    allow_snippet_annotations = var.nginx_config.allow_snippet_annotations
    http_snippet              = var.nginx_config.http_snippet
    extra_config              = var.nginx_config.extra_config
    extra_headers             = var.nginx_config.extra_headers
  })
}