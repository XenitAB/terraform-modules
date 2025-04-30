/**
  * # Azure Service Operator
  *
  * This module is used to add [`azure-service-operator`](https://github.com/Azure/azure-service-operator) to Kubernetes clusters.
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

resource "git_repository_file" "azure_service_operator_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/azure-service-operator/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "azure_service_operator_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/azure-service-operator/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "azure_service_operator" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/azure-service-operator-app.yaml"
  content = templatefile("${path.module}/templates/azure-service-operator-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "azure_service_operator_cluster" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/azure-service-operator/templates/azure-service-operator-cluster.yaml"
  content = templatefile("${path.module}/templates/azure-service-operator-cluster.yaml.tpl", {
    crd_pattern    = var.azure_service_operator_config.cluster_config.crd_pattern
    enable_metrics = var.azure_service_operator_config.cluster_config.enable_metrics
    sync_period    = var.azure_service_operator_config.cluster_config.sync_period
    tenant_name    = var.tenant_name
    environment    = var.environment
    cluster_id     = var.cluster_id
    project        = var.fleet_infra_config.argocd_project_name
    server         = var.fleet_infra_config.k8s_api_server_url
    repo_url       = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "azure_service_operator_tenant" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/azure-service-operator/templates/azure-service-operator-tenants.yaml"
  content = templatefile("${path.module}/templates/azure-service-operator-tenants.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "azure_service_operator_manifests" {
  for_each = { for ns in var.azure_service_operator_config.tenant_namespaces : ns.name => ns }

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/azure-service-operator/manifests/azure-service-operator-${each.key}.yaml"
  content = templatefile("${path.module}/templates/azure-service-operator-manifests.yaml.tpl", {
    tenant_id        = var.tenant_id
    subscription_id  = var.subscription_id
    client_id        = azurerm_user_assigned_identity.tenant[each.key].client_id
    tenant_namespace = each.value.name
  })
}