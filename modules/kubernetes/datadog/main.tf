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
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.4.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

locals {
  container_filter_include = join(" ", formatlist("kube_namespace:%s", var.namespace_include))
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    datadog_site             = var.datadog_site
    location                 = var.location
    environment              = var.environment
    container_filter_include = local.container_filter_include
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
  repository = "https://helm.datadoghq.com"
  chart      = "datadog-operator"
  name       = "datadog-operator"
  namespace  = kubernetes_namespace.this.metadata[0].name

  version = "0.6.3"
  set {
    name  = "apiKey"
    value = var.api_key
  }
  set {
    name  = "appKey"
    value = var.app_key
  }
  set {
    name  = "datadogMonitor.enabled"
    value = true
  }
}

resource "helm_release" "datadog_extras" {
  depends_on = [helm_release.datadog_operator]

  chart     = "${path.module}/charts/datadog-extras"
  name      = "datadog-extras"
  namespace = kubernetes_namespace.this.metadata[0].name
  values    = [local.values]
}
