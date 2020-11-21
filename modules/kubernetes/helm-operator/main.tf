/**
  * # Helm Operator (helm-operator)
  *
  * This module is used to add [`helm-operator`](https://github.com/fluxcd/helm-operator) to Kubernetes clusters.
  *
  * ## Details
  *
  * This module will create a helm-operator instance in each namespace, and not used for fleet-wide configuration.
  *
  * Will be deprecated as soon as Flux v2 module is finished and tested.
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
  helm_repository         = "https://charts.fluxcd.io"
  helm_chart_name         = "helm-operator"
  helm_chart_release_name = "helm-operator"
  helm_chart_version      = "1.2.0"
}

resource "helm_release" "helm_operator" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }

  repository = local.helm_repository
  chart      = local.helm_chart_name
  version    = local.helm_chart_version
  name       = local.helm_chart_release_name
  namespace  = each.key

  values = [templatefile("${path.module}/templates/values.yaml.tpl", { namespace = each.key, acr_name = var.acr_name, helm_operator_credentials = var.helm_operator_credentials, azdo_proxy_enabled = var.azdo_proxy_enabled, azdo_proxy_local_passwords = var.azdo_proxy_local_passwords })]

  set {
    name  = "configureRepositories.repositories[0].password"
    value = var.helm_operator_credentials.secret
  }

  dynamic "set_sensitive" {
    for_each = {
      for s in ["azdo-proxy"] :
      s => s
      if var.azdo_proxy_enabled == true
    }
    content {
      name  = "git.config.data"
      value = <<EOF
        [url "http://${var.azdo_proxy_local_passwords[each.key]}@azdo-proxy.azdo-proxy"]
          insteadOf = https://dev.azure.com
        EOF
    }
  }
}
