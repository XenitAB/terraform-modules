/**
  * # Popeye (popeye)
  *
  * This module is used to add Popeye [`popeye`](https://github.com/derailed/popeye) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.7.0"
      source  = "hashicorp/azurerm"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

data "azurerm_storage_account" "log" {
  name                = var.popeye_config.storage_account.account_name
  resource_group_name = var.popeye_config.storage_account.resource_group_name
}

resource "kubernetes_namespace" "popeye" {
  metadata {
    name = "popeye"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "helm_release" "popeye" {
  depends_on = [kubernetes_namespace.popeye]

  chart       = "${path.module}/charts/popeye"
  name        = "popeye"
  namespace   = "popeye"
  max_history = 3
  values = [templatefile("${path.module}/charts/popeye/values.yaml.tpl", {
    allowed_registries   = var.popeye_config.allowed_registries
    client_id            = azurerm_user_assigned_identity.popeye.client_id
    cron_jobs            = var.popeye_config.cron_jobs
    location             = var.location
    resource_group_name  = var.popeye_config.storage_account.resource_group_name
    storage_account_name = data.azurerm_storage_account.log.name
    storage_account_key  = data.azurerm_storage_account.log.primary_access_key
    file_share_size      = var.popeye_config.storage_account.file_share_size
  })]
}