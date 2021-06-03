/**
  * # External DNS (external-dns)
  *
  * This module is used to add [`external-dns`](https://github.com/kubernetes-sigs/external-dns) to Kubernetes clusters.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.2"
    }
  }
}

locals {
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "external-dns"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "external-dns"
  }
}

resource "helm_release" "external_dns" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  name       = "external-dns"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "5.0.2"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    provider     = var.dns_provider,
    sources      = var.sources,
    azure_config = var.azure_config,
    aws_config   = var.aws_config,
    txt_owner_id = var.txt_owner_id,
  })]
}

resource "helm_release" "external_dns_extras" {
  depends_on = [helm_release.external_dns]

  chart     = "${path.module}/charts/external-dns-extras"
  name      = "external-dns-extras"
  namespace = kubernetes_namespace.this.metadata[0].name

  set {
    name  = "resourceID"
    value = var.azure_config.resource_id
  }

  set {
    name  = "clientID"
    value = var.azure_config.client_id
  }
}
