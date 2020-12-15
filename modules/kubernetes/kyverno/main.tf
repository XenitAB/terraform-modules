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
  namespace = "kyverno"
  version   = "1.3.0-rc8"
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
  version    = local.version
  #values     = [file("${path.module}/templates/kyverno-values.yaml.tpl")]
}

resource "helm_release" "kyverno_extras" {
  depends_on = [helm_release.kyverno]

  chart     = "${path.module}/charts/kyverno-extras"
  name      = "kyverno-extras"
  namespace = kubernetes_namespace.this.metadata[0].name
  values    = [templatefile("${path.module}/templates/kyverno-extra-values.yaml.tpl", { excluded_namespaces = var.excluded_namespaces })]
}
