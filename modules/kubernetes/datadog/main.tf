/**
  * # Datadog
  *
  * Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.
  * This module is built to only gather application data.
  * API vs APP key.
  * API is used to send metrics to datadog from the agents.
  * APP key is used to be able to manage configuration inside datadog like alarms.
  * https://docs.datadoghq.com/account_management/api-app-keys/
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
  container_filter_include = join(" ", formatlist("kube_namespace:%s", var.namespace_include))
  apm_ignore_resources     = join(",", formatlist("%s", var.apm_ignore_resources))
}

resource "git_repository_file" "datadog_operator" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/datadog-operator.yaml"
  content = templatefile("${path.module}/templates/datadog-operator.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "datadog" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/datadog-operator/datadog-agent.yaml"
  content = templatefile("${path.module}/templates/datadog-agent.yaml.tpl", {
    location             = var.location_short
    environment          = var.environment
    datadog_site         = var.datadog_site
    namespace_include    = local.container_filter_include
    apm_ignore_resources = local.apm_ignore_resources
  })
}

resource "git_repository_file" "azure_config" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/datadog-operator/azure-config.yaml"
  content = templatefile("${path.module}/templates/azure-config.yaml.tpl", {
    key_vault_name = var.azure_config.azure_key_vault_name
    tenant_id      = azurerm_user_assigned_identity.datadog.tenant_id
    client_id      = azurerm_user_assigned_identity.datadog.client_id
  })
}
