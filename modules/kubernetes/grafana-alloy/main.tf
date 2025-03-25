/**
  * # Grafana Alloy
  *
  * Adds [Grafana Alloy](https://github.com/grafana/alloy/tree/main/operations/helm) to a Kubernetes cluster.
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
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "grafana_alloy_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana_alloy/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "grafana_alloy_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana_alloy/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "grafana_alloy_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/grafana-alloy-app.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy-app.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "grafana_alloy" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-alloy/templates/grafana-alloy.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy.yaml.tpl", {
    project              = var.fleet_infra_config.argocd_project_name
    server               = var.fleet_infra_config.k8s_api_server_url
    azure_config         = var.azure_config
    grafana_alloy_config = var.grafana_alloy_config
    client_id            = data.azurerm_user_assigned_identity.xenit.client_id
    tenant_id            = data.azurerm_user_assigned_identity.xenit.tenant_id
  })
}

resource "git_repository_file" "grafana_alloy_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-alloy/templates/grafana-alloy-extras.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "grafana_alloy_manifests" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-alloy/manifests/grafana-alloy-extras.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy-manifests.yaml.tpl", {
    azure_config         = var.azure_config
    grafana_alloy_config = var.grafana_alloy_config
    client_id            = data.azurerm_user_assigned_identity.xenit.client_id
    tenant_id            = data.azurerm_user_assigned_identity.xenit.tenant_id
  })
}
