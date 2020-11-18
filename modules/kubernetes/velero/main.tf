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
  values = templatefile("${path.module}/templates/values.yaml.tpl", { cloud_provider = var.cloud_provider, azure_resource_group = var.azure_resource_group, azure_storage_account_name = var.azure_storage_account_name, azure_storage_account_container = var.azure_storage_account_container })
}

resource "kubernetes_namespace" "velero" {
  metadata {
    labels = {
      name = "velero"
    }
    name = "velero"
  }
}

resource "kubernetes_secret" "velero" {
  metadata {
    name      = "velero"
    namespace = kubernetes_namespace.velero.metadata[0].name
  }

  data = {
    "cloud" = yamlencode({
      AZURE_SUBSCRIPTION_ID = var.azure_subscription_id
      AZURE_RESOURCE_GROUP  = var.azure_resource_group
      AZURE_CLOUD_NAME      = "AzurePublicCloud"
    })
  }
}

resource "helm_release" "velero" {
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  name       = "velero"
  namespace  = kubernetes_namespace.velero.metadata[0].name
  version    = "2.13.6"
  values     = [local.values]
}

resource "helm_release" "velero_extras" {
  depends_on = [helm_release.velero]

  chart     = "${path.module}/charts/velero-extras"
  name      = "velero-extras"
  namespace = kubernetes_namespace.velero.metadata[0].name

  set {
    name  = "resourceID"
    value = var.azure_resource_id
  }

  set {
    name  = "clientID"
    value = var.azure_client_id
  }
}
