/**
  * # Certificate manager (cert-manager)
  *
  * This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
  }
}

resource "git_repository_file" "cert_manager_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/cert-manager/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "cert_manager_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/cert-manager/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "cert_manager_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/cert-manager-app.yaml"
  content = templatefile("${path.module}/templates/cert-manager-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "cert_manager" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/cert-manager/templates/cert-manager.yaml"
  content = templatefile("${path.module}/templates/cert-manager.yaml.tpl", {
    tenant_name         = var.tenant_name
    environment         = var.environment
    project             = var.fleet_infra_config.argocd_project_name
    server              = var.fleet_infra_config.k8s_api_server_url
    client_id           = azurerm_user_assigned_identity.cert_manager.client_id
    gateway_api_enabled = var.gateway_api_enabled
  })
}

resource "git_repository_file" "cert_manager_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/cert-manager/templates/cert-manager-extras.yaml"
  content = templatefile("${path.module}/templates/cert-manager-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "cert_manager_manifests" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/cert-manager/manifests/cert-manager-extras.yaml"
  content = templatefile("${path.module}/templates/cert-manager-manifests.yaml.tpl", {
    aad_groups               = var.aad_groups
    namespaces               = var.namespaces
    acme_server              = var.acme_server
    client_id                = azurerm_user_assigned_identity.cert_manager.client_id
    dns_zones                = var.dns_zones
    notification_email       = var.notification_email
    resource_group_name      = var.global_resource_group_name
    subscription_id          = var.subscription_id
    gateway_api_enabled      = var.gateway_api_enabled
    gateway_solver_name      = var.gateway_api_config.gateway_name
    gateway_solver_namespace = var.gateway_api_config.gateway_namespace
    logs_enabled             = var.logs_enabled
  })
}
