/**
  * # Promtail
  *
  * Adds [Promtail](https://github.com/grafana/helm-charts/tree/main/charts/promtail) to a Kubernetes cluster.
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

locals {
  namespace       = "promtail"
  k8s_secret_name = "xenit-proxy-certificate" #tfsec:ignore:general-secrets-no-plaintext-exposure
  azure_config = {
    azure_key_vault_name = var.azure_config.azure_key_vault_name
    keyvault_secret_name = "xenit-proxy-certificate"
  }

}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/promtail.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id,
  })
}

resource "git_repository_file" "promtail" {
  path = "platform/${var.cluster_id}/promtail/promtail.yaml"
  content = templatefile("${path.module}/templates/promtail.yaml.tpl", {
    region                = var.region,
    environment           = var.environment,
    cluster_name          = var.cluster_name,
    namespace             = local.namespace,
    excluded_namespaces   = var.excluded_namespaces,
    k8s_secret_name       = local.k8s_secret_name,
    loki_address          = var.loki_address,
    grafana_cloud_address = var.grafana_cloud_address
    azure_config          = local.azure_config,
    client_id             = data.azurerm_user_assigned_identity.xenit.client_id,
    tenant_id             = data.azurerm_user_assigned_identity.xenit.tenant_id,
  })
}
