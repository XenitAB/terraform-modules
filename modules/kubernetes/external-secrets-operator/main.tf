/**
  * # external-secrets-operator (external-secrets-operator)
  *
  * This module is used to deploy External Secrets Operator (https://external-secrets.io/)
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.57.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
  }
}

resource "git_repository_file" "external_secrets_operator" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/external-secrets-operator.yaml"
  content = templatefile("${path.module}/templates/external-secrets-operator.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    config      = var.external_secrets_config
  })
}