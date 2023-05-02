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
    git = {
      source  = "xenitab/git"
      version = "0.0.1"
    }
  }
}

locals {
  apm_ignore_resources = join(",", formatlist("%s", var.apm_ignore_resources))
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/datadog.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "datadog_operator" {
  path = "platform/${var.cluster_id}/datadog-operator/datadog-operator.yaml"
  content = templatefile("${path.module}/templates/datadog-operator.yaml", {
  })
}
resource "git_repository_file" "datadog" {
  path = "platform/${var.cluster_id}/datadog/datadog.yaml"
  content = templatefile("${path.module}/templates/datadog.yaml.tpl", {
    location             = var.location,
    environment          = var.environment,
    datadog_site         = var.datadog_site,
    namespace_include    = var.namespace_include,
    apm_ignore_resources = local.apm_ignore_resources,
  })
}

resource "git_repository_file" "azure_config" {
  for_each = {
    for s in ["azure-config"] :
    s => s
    if var.cloud_provider == "azure"
  }

  path = "platform/${var.cluster_id}/datadog-operator/azure-config.yaml"
  content = templatefile("${path.module}/templates/azure-config.yaml.tpl", {
    key_vault_name = var.azure_config.azure_key_vault_name
    tenant_id      = var.azure_config.identity.tenant_id
    resource_id    = var.azure_config.identity.resource_id
    client_id      = var.azure_config.identity.client_id
  })
}

resource "git_repository_file" "aws_config" {
  for_each = {
    for s in ["aws-config"] :
    s => s
    if var.cloud_provider == "aws"
  }

  path = "platform/${var.cluster_id}/datadog-operator/aws-config.yaml"
  content = templatefile("${path.module}/templates/aws-config.yaml.tpl", {
    role_arn = var.aws_config.role_arn
  })
}
