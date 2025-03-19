/**
  * # Nginx Gateway Fabric
  *
  * This module is used to add [`nginx-gateway-fabric`](https://docs.nginx.com/nginx-gateway-fabric/) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "ingress_nginx" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/nginx-gateway-fabric.yaml"
  content = templatefile("${path.module}/templates/nginx-gateway-fabric.yaml.tpl", {
    logging_level             = var.gateway_config.logging_level
    replica_count             = var.gateway_config.replica_count
    telemetry_enabled         = var.gateway_config.telemetry_enabled
    telemetry_config          = var.gateway_config.telemetry_config
    allow_snippet_annotations = var.nginx_config.allow_snippet_annotations
    http_snippet              = var.nginx_config.http_snippet
    extra_config              = var.nginx_config.extra_config
    extra_headers             = var.nginx_config.extra_headers
    project                   = var.fleet_infra_config.argocd_project_name
    server                    = var.fleet_infra_config.k8s_api_server_url
  })
}