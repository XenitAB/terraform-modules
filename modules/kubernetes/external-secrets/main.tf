/**
  * # External Secrets
  *
  * Adds [`external-secrets`](https://github.com/external-secrets/kubernetes-external-secrets) to a Kubernetes clusters.
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}

locals {
  namespace = "external-secrets"
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    aws_config = var.aws_config
  })
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = local.namespace
    }
    name = local.namespace
  }
}

resource "helm_release" "external_secrets" {
  repository = "https://external-secrets.github.io/kubernetes-external-secrets/"
  chart      = "kubernetes-external-secrets"
  name       = "external-secrets"
  namespace  = kubernetes_namespace.this.metadata[0].name
  skip_crds  = true # let the custom resource manager install the CRDs
  version    = "6.0.0"
  values     = [local.values]
}
