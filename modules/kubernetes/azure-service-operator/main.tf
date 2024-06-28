/**
  * # Azure Service Operator
  *
  * This module is used to add [`azure-service-operator`](https://github.com/Azure/azure-service-operator) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/azure-service-operator.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "azure_service_operator_cluster" {
  path = "platform/${var.cluster_id}/azure-service-operator/azure-service-operator-cluster.yaml"
  content = templatefile("${path.module}/templates/azure-service-operator-cluster.yaml.tpl", {
    client_id      = azurerm_user_assigned_identity.azure_service_operator.client_id,
    crd_pattern    = var.azure_service_operator_config.cluster_config.crd_pattern,
    enable_metrics = var.azure_service_operator_config.cluster_config.enable_metrics,
    sync_period    = var.azure_service_operator_config.cluster_config.sync_period,
  })
}

resource "git_repository_file" "azure_service_operator_tenant" {
  for_each = { for ns in var.azure_service_operator_config.tenant_namespaces : ns.name => ns }

  path = "platform/${var.cluster_id}/azure-service-operator/azure-service-operator-${each.key}.yaml"
  content = templatefile("${path.module}/templates/azure-service-operator-tenant.yaml.tpl", {
    client_id         = data.azurerm_user_assigned_identity.tenant[each.key].client_id,
    crd_pattern       = each.value.crd_pattern,
    enable_metrics    = each.value.enable_metrics,
    sync_period       = each.value.sync_period,
    target_namespaces = each.value.name,
  })
}