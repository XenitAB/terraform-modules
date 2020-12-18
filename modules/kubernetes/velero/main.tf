/**
  * # Velero
  *
  * This module is used to add [`velero`](https://github.com/vmware-tanzu/velero) to Kubernetes clusters.
  *
  * ![Terraform Graph](files/graph.svg "Terraform Graph")
  *
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
  namespace = "velero"
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    cloud_provider = var.cloud_provider,
    azure_config   = var.azure_config
    aws_config     = var.aws_config
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

resource "helm_release" "velero" {
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  name       = "velero"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "2.14.0"
  values     = [local.values]
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
