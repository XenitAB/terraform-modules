/**
  * # New Relic
  *
  * This module is used to install [`New Relic`](https://github.com/newrelic/helm-charts) in a Kubernetes cluster.
  *
  * ## Details
  *
  * New Relic monitoring is an alternative to Datadog for end users. It works very much in a similar way, running exporters on all nodes and exporting data. The exporter is meant to be configured for
  * specific namespaces so that all metrics in the cluster are not exported. Check the [New Relic Kubernetes
  * Documentation](https://docs.newrelic.com/docs/integrations/kubernetes-integration/installation/kubernetes-integration-install-configure/) for more information.
  */

terraform {
  required_version = "1.1.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
  }
}

locals {
  namespace_paths = [for v in var.namespace_include : "/var/log/containers/*_${v}_*.log"]
  fluent_bit_path = join(",", local.namespace_paths)
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "newrelic"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "newrelic"
  }
}

resource "helm_release" "this" {
  repository = "https://helm-charts.newrelic.com"
  chart      = "nri-bundle"
  name       = "nri-bundle"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "3.1.2"

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    cluster_name    = var.cluster_name
    license_key     = var.license_key
    fluent_bit_path = local.fluent_bit_path
  })]
}
