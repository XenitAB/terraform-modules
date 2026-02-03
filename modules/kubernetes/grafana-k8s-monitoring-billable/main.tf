/**
  * # grafana-k8s-monitoring-billable
  *
  * Lightweight version of grafana-k8s-monitoring that only collects node metrics for billing purposes.
  * Sends only node metrics to Grafana Cloud.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.57.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
  }
}

resource "git_repository_file" "grafana_k8s_monitoring_billable_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring-billable/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "grafana_k8s_monitoring_billable_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/grafana-k8s-monitoring-billable-app.yaml"
  content = templatefile("${path.module}/templates/grafana-k8s-monitoring-billable-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "grafana_k8s_monitoring_billable" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring-billable/templates/grafana-k8s-monitoring-billable.yaml"
  content = templatefile("${path.module}/templates/grafana-k8s-monitoring-billable.yaml.tpl", {
    tenant_name  = var.tenant_name
    environment  = var.environment
    project      = var.fleet_infra_config.argocd_project_name
    server       = var.fleet_infra_config.k8s_api_server_url
    cluster_name = var.cluster_name
  })
}

resource "git_repository_file" "grafana_k8s_monitoring_billable_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring-billable/templates/grafana-k8s-monitoring-billable-extras.yaml"
  content = templatefile("${path.module}/templates/grafana-k8s-monitoring-billable-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "secret_provider_class" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring-billable/manifests/secret-provider-class.yaml"
  content = templatefile("${path.module}/templates/secret-provider-class.yaml.tpl", {
    tenant_id      = azurerm_user_assigned_identity.grafana_k8s_monitor_billable.tenant_id
    client_id      = azurerm_user_assigned_identity.grafana_k8s_monitor_billable.client_id
    key_vault_name = var.azure_key_vault_name
  })
}
