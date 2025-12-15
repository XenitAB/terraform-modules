/**
  * # Envoy Gateway
  *
  * This module is used to add [`envoy-gateway`](https://gateway.envoyproxy.io/docs/) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
  }
}

resource "git_repository_file" "envoy_gateway" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/envoy-gateway.yaml"
  content = templatefile("${path.module}/templates/envoy-gateway.yaml.tpl", {
    envoy_gateway_config = var.envoy_gateway_config
    tenant_name          = var.tenant_name
    environment          = var.environment
    project              = var.fleet_infra_config.argocd_project_name
    server               = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "envoy_gateway_require_tls_kyverno" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/envoy-gateway-require-tls-kyverno.yaml"
  content = templatefile("${path.module}/templates/envoy-gateway-require-tls-kyverno.yaml.tpl", {
  })
}
