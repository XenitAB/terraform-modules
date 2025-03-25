/**
  * # Promtail
  *
  * Adds [Promtail](https://github.com/grafana/helm-charts/tree/main/charts/promtail) to a Kubernetes cluster.
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

locals {
  namespace       = "promtail"
  k8s_secret_name = "xenit-proxy-certificate" #tfsec:ignore:general-secrets-no-plaintext-exposure
  azure_config = {
    azure_key_vault_name = var.azure_config.azure_key_vault_name
    keyvault_secret_name = "xenit-proxy-certificate"
  }

}

resource "git_repository_file" "promtail_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/promtail/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "promtail_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/promtail/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "promtail_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/promtail-app.yaml"
  content = templatefile("${path.module}/templates/promtail-app.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "promtail" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/promtail/templates/promtail.yaml"
  content = templatefile("${path.module}/templates/promtail.yaml.tpl", {
    region              = var.region
    environment         = var.environment
    cluster_name        = var.cluster_name
    namespace           = local.namespace
    excluded_namespaces = var.excluded_namespaces
    k8s_secret_name     = local.k8s_secret_name
    loki_address        = var.loki_address
    azure_config        = local.azure_config
    client_id           = data.azurerm_user_assigned_identity.xenit.client_id
    tenant_id           = data.azurerm_user_assigned_identity.xenit.tenant_id
    project             = var.fleet_infra_config.argocd_project_name
    server              = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "promtail_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/cert-manager/templates/promtail-extras.yaml"
  content = templatefile("${path.module}/templates/promtail-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "promtail_manifests" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/cert-manager/manifests/promtail-extras.yaml"
  content = templatefile("${path.module}/templates/promtail-manifests.yaml.tpl", {
    k8s_secret_name = local.k8s_secret_name
    azure_config    = local.azure_config
    client_id       = data.azurerm_user_assigned_identity.xenit.client_id
    tenant_id       = data.azurerm_user_assigned_identity.xenit.tenant_id
  })
}
