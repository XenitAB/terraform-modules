/**
  * # Datadog
  *
  * Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

locals {
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    datadog_site = var.datadog_site
    api_key      = var.api_key
    location     = var.location
    environment  = var.environment
  })
}

resource "helm_release" "datadog" {
  repository       = "https://helm.datadoghq.com"
  chart            = "datadog"
  name             = "datadog"
  namespace        = "datadog"
  create_namespace = true
  version          = "2.6.0"
  values           = [local.values]
}
