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

resource "git_repository_file" "velero" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/velero.yaml"
  content = templatefile("${path.module}/templates/velero.yaml.tpl", {
    azure_config        = var.azure_config,
    client_id           = azurerm_user_assigned_identity.velero.client_id,
    environment         = var.environment,
    resource_group_name = var.resource_group_name,
    subscription_id     = var.subscription_id,
    unique_suffix       = var.unique_suffix,
    tenant_id           = azurerm_user_assigned_identity.velero.tenant_id,
  })
}

resource "git_repository_file" "velero_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/velero/velero-extras.yaml"
  content = templatefile("${path.module}/templates/velero-extras.yaml.tpl", {
  })
}
