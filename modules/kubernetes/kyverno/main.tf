terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.2"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "kyverno"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "kyverno"
  }
}

resource "helm_release" "kyverno" {
  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno"
  name       = "kyverno"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v1.3.6"
}

resource "helm_release" "kyverno_extras" {
  depends_on = [helm_release.kyverno]

  chart     = "${path.module}/charts/kyverno-extras"
  name      = "kyverno-extras"
  namespace = kubernetes_namespace.this.metadata[0].name
  values    = [templatefile("${path.module}/templates/kyverno-extra-values.yaml.tpl", { excluded_namespaces = var.excluded_namespaces })]
}
