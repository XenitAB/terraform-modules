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
  required_version = ">= 1.1.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
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

data "helm_template" "datadog_operator" {
  repository   = "https://helm.datadoghq.com"
  chart        = "datadog-operator"
  name         = "datadog-operator"
  version      = "0.7.0"
  api_versions = ["apiextensions.k8s.io/v1/CustomResourceDefinition"]
}

data "kubectl_file_documents" "datadog_operator" {
  content = data.helm_template.datadog_operator.manifest
}

resource "kubectl_manifest" "datadog_operator" {
  for_each = {
    for k, v in data.kubectl_file_documents.datadog_operator.manifests :
    k => v
    if can(regex("^/apis/apiextensions.k8s.io/v1/customresourcedefinitions/", k))
  }
  server_side_apply = true
  apply_only        = true
  yaml_body         = each.value
}

resource "helm_release" "datadog_operator" {
  depends_on = [kubectl_manifest.datadog_operator]

  repository  = "https://helm.datadoghq.com"
  chart       = "datadog-operator"
  name        = "datadog-operator"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "0.7.0"
  max_history = 3

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

  chart       = "${path.module}/charts/datadog-extras"
  name        = "datadog-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  values      = [local.values]
}
