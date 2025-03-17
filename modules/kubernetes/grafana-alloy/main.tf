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

resource "git_repository_file" "grafana_alloy" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-alloy.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy.yaml.tpl", {
    azure_config         = var.azure_config,
    grafana_alloy_config = var.grafana_alloy_config,
    client_id            = data.azurerm_user_assigned_identity.xenit.client_id,
    tenant_id            = data.azurerm_user_assigned_identity.xenit.tenant_id,
    tenant_name          = var.tenant_name
    cluster_id           = var.cluster_id
  })
}

resource "git_repository_file" "grafana_alloy_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/grafana-alloy/grafana-alloy-extras.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy-extras.yaml.tpl", {
    azure_config         = var.azure_config,
    grafana_alloy_config = var.grafana_alloy_config,
    client_id            = data.azurerm_user_assigned_identity.xenit.client_id,
    tenant_id            = data.azurerm_user_assigned_identity.xenit.tenant_id,
  })
}
