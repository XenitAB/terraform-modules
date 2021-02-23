terraform {
  required_version = "0.13.5"

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
  namespace = "kyverno"
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = local.namespace
    }
    name = local.namespace
  }
}

resource "helm_release" "kyverno" {
  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno"
  name       = "kyverno"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "1.3.0-rc11"
}

resource "helm_release" "kyverno_extras" {
  depends_on = [helm_release.kyverno]

  chart     = "${path.module}/charts/kyverno-extras"
  name      = "kyverno-extras"
  namespace = kubernetes_namespace.this.metadata[0].name
  values    = [templatefile("${path.module}/templates/kyverno-extra-values.yaml.tpl", { excluded_namespaces = var.excluded_namespaces })]
}
