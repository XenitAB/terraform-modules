/**
  * # Velero
  *
  * This module is used to add [`velero`](https://github.com/vmware-tanzu/velero) to Kubernetes clusters.
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

resource "git_repository_file" "velero_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/velero/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "velero_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/velero/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "velero_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/velero-app.yaml"
  content = templatefile("${path.module}/templates/velero-app.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "velero" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/velero/templates/velero.yaml"
  content = templatefile("${path.module}/templates/velero.yaml.tpl", {
    azure_config        = var.azure_config
    client_id           = azurerm_user_assigned_identity.velero.client_id
    environment         = var.environment
    resource_group_name = var.resource_group_name
    subscription_id     = var.subscription_id
    unique_suffix       = var.unique_suffix
    tenant_id           = azurerm_user_assigned_identity.velero.tenant_id
    tenant_name         = var.tenant_name
    cluster_id          = var.cluster_id
    project             = var.fleet_infra_config.argocd_project_name
    server              = var.fleet_infra_config.k8s_api_server_url
    repo_url            = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "velero_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/velero/templates/velero-extras.yaml"
  content = templatefile("${path.module}/templates/velero-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "velero_manifests" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/velero/manifests/velero-extras.yaml"
  content = templatefile("${path.module}/templates/velero-manifests.yaml.tpl", {
  })
}
