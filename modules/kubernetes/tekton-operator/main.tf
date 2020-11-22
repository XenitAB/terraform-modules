/**
  * # TektonCD Operator
  *
  * This module is used to add [`tekton-operator`](https://github.com/tektoncd/operator) to Kubernetes clusters.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

locals {
  helm_release_name = "tekton-operator"
  namespace         = "tekton-operator"
}

resource "kubernetes_namespace" "tekton_operator" {
  metadata {
    labels = {
      name = local.namespace
    }
    name = local.namespace
  }
}

resource "helm_release" "tekton_operator" {
  name      = local.helm_release_name
  chart     = "${path.module}/charts/tekton-operator"
  namespace = kubernetes_namespace.tekton_operator.metadata[0].name
  values    = [templatefile("${path.module}/templates/values.yaml.tpl", {})]
}

resource "helm_release" "tekton_operator_extras" {
  depends_on = [helm_release.tekton_operator]
  name       = "${local.helm_release_name}-extras"
  chart      = "${path.module}/charts/tekton-operator-extras"
  namespace  = kubernetes_namespace.tekton_operator.metadata[0].name
}
