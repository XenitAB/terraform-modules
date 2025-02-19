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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
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
  path       = "clusters/${var.cluster_id}/grafana-alloy-controller.yaml"
  depends_on = [kubernetes_namespace.this]
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id,
  })
}

resource "git_repository_file" "grafana_alloy" {
  path = "platform/${var.cluster_id}/grafana-alloy/grafana-alloy-controller.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy-controller.yaml.tpl", {
    azure_config         = var.azure_config,
    grafana_alloy_config = var.grafana_alloy_config,
    client_id            = data.azurerm_user_assigned_identity.xenit.client_id,
    tenant_id            = data.azurerm_user_assigned_identity.xenit.tenant_id,
  })
}
