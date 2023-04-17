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
  container_filter_include = join(" ", formatlist("kube_namespace:%s", var.namespace_include))
  apm_ignore_resources     = join(",", formatlist("%s", var.apm_ignore_resources))
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/datadog.yaml" # "clusters/we-dev-aks1/datadog.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

resource "git_repository_file" "datadog-operator" {
  path = "platform/${var.cluster_id}/datadog-operator/datadog-operator.yaml" # "platform/we-dev-aks1/datadog-operator.yaml"
  content = templatefile("${path.module}/templates/datadog-operator.yaml.tpl", {
    app_key     = var.app_key,
    api_key     = var.api_key,
    tenant_id   = var.tenant_id,
    client_id   = var.client_id,
    resource_id = var.resource_id,
  })
}

resource "git_repository_file" "datadog" {
  path = "platform/${var.cluster_id}/datadog/datadog.yaml" # "platform/we-dev-aks1/datadog.yaml"
  content = templatefile("${path.module}/templates/datadog.yaml.tpl", {
    app_key              = var.app_key,
    api_key              = var.api_key,
    location             = var.location,
    environment          = var.environment,
    datadog_site         = var.datadog_site,
    namespace_include    = local.container_filter_include,
    apm_ignore_resources = local.apm_ignore_resources,
  })
}
