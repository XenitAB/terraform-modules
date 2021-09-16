/**
  * # Velero
  *
  * This module is used to add [`velero`](https://github.com/vmware-tanzu/velero) to Kubernetes clusters.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.4.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "velero"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "velero"
  }
}

resource "helm_release" "velero" {
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  name       = "velero"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "2.23.6"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    cloud_provider = var.cloud_provider,
    azure_config   = var.azure_config,
    aws_config     = var.aws_config,
  })]
}

resource "helm_release" "velero_extras" {
  depends_on = [helm_release.velero]

  chart     = "${path.module}/charts/velero-extras"
  name      = "velero-extras"
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
