/**
  * # Grafana Loki
  *
  * This module is used to add [`loki`](https://github.com/grafana/loki) to Kubernetes clusters (tested with AKS).
  *
  * ## Details
  *
  * This module will also add `minio` (S3 Gateway to Azure Storage Account), `fluent-bit` and `grafana`.
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    azurerm = {
      version = "2.47.0"
      source  = "hashicorp/azurerm"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}

resource "azurerm_storage_account" "loki" {
  name                     = local.storage_account_name
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  account_tier             = var.storage_account_configuration.account_tier
  account_replication_type = var.storage_account_configuration.account_replication_type
  account_kind             = var.storage_account_configuration.account_kind
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "loki" {
  storage_account_name  = azurerm_storage_account.loki.name
  name                  = var.storage_container_name
  container_access_type = "private"
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = var.kubernetes_namespace_name
    }
    name = var.kubernetes_namespace_name
  }
}

resource "helm_release" "minio" {
  name       = var.minio_helm_release_name
  repository = var.minio_helm_repository
  chart      = var.minio_helm_chart_name
  version    = "8.0.0"
  namespace  = kubernetes_namespace.this.metadata[0].name

  values = [
    templatefile("${path.module}/templates/minio-values.yaml.tpl", {}),
  ]

  set_sensitive {
    name  = "accessKey"
    value = azurerm_storage_account.loki.name
  }

  set_sensitive {
    name  = "secretKey"
    value = azurerm_storage_account.loki.primary_access_key
  }
}

resource "helm_release" "loki_stack" {
  name       = var.loki_helm_release_name
  repository = var.loki_helm_repository
  chart      = var.loki_helm_chart_name
  version    = "2.0.0"
  namespace  = kubernetes_namespace.this.metadata[0].name

  values = [
    templatefile("${path.module}/templates/loki-stack-values.yaml.tpl", {}),
    templatefile("${path.module}/templates/fluent-bit-values.yaml.tpl", {}),
    templatefile("${path.module}/templates/loki-values.yaml.tpl", {}),
  ]

  set_sensitive {
    name  = "loki.config.storage_config.aws.s3"
    value = "s3://${azurerm_storage_account.loki.name}:${urlencode(azurerm_storage_account.loki.primary_access_key)}@${helm_release.minio.name}.${kubernetes_namespace.this.metadata[0].name}.svc.cluster.local.:9000"
  }

  set {
    name  = "loki.config.storage_config.aws.bucketnames"
    value = azurerm_storage_container.loki.name
  }
}
