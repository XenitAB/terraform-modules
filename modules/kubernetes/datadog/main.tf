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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
  }
}

locals {
  container_filter_include = join(" ", formatlist("kube_namespace:%s", var.namespace_include))
  apm_ignore_resources     = join(",", formatlist("%s", var.apm_ignore_resources))
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    datadog_site             = var.datadog_site
    location                 = var.location
    environment              = var.environment
    container_filter_include = local.container_filter_include
    apm_ignore_resources     = local.apm_ignore_resources
  })
  values_datadog_operator = templatefile("${path.module}/templates/datadog-operator-values.yaml.tpl", {
    api_key = var.api_key
    app_key = var.app_key
  })
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "datadog"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "datadog"
  }
}

resource "helm_release" "datadog_operator" {
  repository  = "https://helm.datadoghq.com"
  chart       = "datadog-operator"
  name        = "datadog-operator"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "0.8.4"
  max_history = 3
  values      = [local.values_datadog_operator]
}

resource "helm_release" "datadog_extras" {
  depends_on = [helm_release.datadog_operator]

  chart       = "${path.module}/charts/datadog-extras"
  name        = "datadog-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  values      = [local.values]
}
