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
  }
}

resource "git_repository_file" "envoy_gateway_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/envoy-gateway/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "envoy_gateway_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/envoy-gateway/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

resource "git_repository_file" "envoy_gateway_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/envoy-gateway-app.yaml"
  content = templatefile("${path.module}/templates/envoy-gateway-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "envoy_gateway" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/envoy-gateway/templates/envoy-gateway.yaml"
  content = templatefile("${path.module}/templates/envoy-gateway.yaml.tpl", {
    envoy_gateway_config = var.envoy_gateway_config
    tenant_name          = var.tenant_name
    environment          = var.environment
    project              = var.fleet_infra_config.argocd_project_name
    server               = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "envoy_gateway_security_policy" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/envoy-gateway/templates/security-policy.yaml"
  content = templatefile("${path.module}/templates/security-policy.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
  })
}

resource "git_repository_file" "envoy_gateway_resources" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/envoy-gateway/templates/gateway-resources.yaml"
  content = templatefile("${path.module}/templates/gateway-resources.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
  })
}
