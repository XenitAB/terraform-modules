/**
  * # TektonCD Operator
  *
  * This module is used to add [`tekton-operator`](https://github.com/tektoncd/operator) to Kubernetes clusters.
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
  helm_release_name = "tekton-operator"
  namespace         = "tekton"
}

resource "helm_release" "tekton_operator" {
  name             = local.helm_release_name
  chart            = "${path.module}/charts/tekton-operator"
  namespace        = local.namespace
  values           = [templatefile("${path.module}/templates/values.yaml.tpl", {})]
  create_namespace = true
}
