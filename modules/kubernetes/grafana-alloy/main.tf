/**
  * # Grafana Alloy
  *
  * Adds [Grafana Alloy](https://github.com/grafana/alloy/tree/main/operations/helm) to a Kubernetes cluster.
  * Finish this at some point
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "3.107.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "grafana-alloy"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "grafana-alloy"
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/grafana-alloy-controller.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id,
  })
}

resource "git_repository_file" "grafana_alloy" {
  path = "platform/${var.cluster_id}/grafana-alloy/grafana-alloy-controller.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy-controller.yaml.tpl", {
  })
}

resource "git_repository_file" "azure_config" {
  for_each = {
    for s in ["azure-config"] :
    s => s
  }

  path = "platform/${var.cluster_id}/grafana-alloy/azure-config.yaml"
  content = templatefile("${path.module}/templates/azure-config.yaml.tpl", {
    key_vault_name                      = var.azure_config.azure_key_vault_name,
    tenant_id                           = azurerm_user_assigned_identity.grafana_alloy.tenant_id,
    client_id                           = azurerm_user_assigned_identity.grafana_alloy.client_id,
    grafana_otelcol_auth_basic_username = var.grafana_otelcol_auth_basic_username
    grafana_otelcol_exporter_endpoint   = var.grafana_otelcol_auth_basic_username
  })
}
