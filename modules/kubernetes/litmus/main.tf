/**
  * # Litmus (litmus)
  *
  * This module is used to add Litmus chaos engineering [`litmuschaos`](https://litmuschaos.io/) to Kubernetes clusters.
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

data "azurerm_key_vault" "core" {
  name                = var.azure_key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "mongodb" {
  name         = "litmus-mongodb-root-password"
  key_vault_id = data.azurerm_key_vault.core.id
}

resource "kubernetes_namespace" "litmus" {
  metadata {
    name = "litmus"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "git_repository_file" "kustomization" {
  depends_on = [kubernetes_namespace.litmus]

  path = "clusters/${var.cluster_id}/litmuschaos.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "litmus" {
  depends_on = [kubernetes_namespace.litmus]

  path = "platform/${var.cluster_id}/litmus/litmuschaos.yaml"
  content = templatefile("${path.module}/templates/litmuschaos.yaml.tpl", {
    cluster_id            = var.cluster_id
    mongodb_root_password = data.azurerm_key_vault_secret.mongodb.value
  })
}