# Module requirements
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

resource "kubernetes_namespace" "aad_pod_identity" {
  metadata {
    name = var.aad_pod_identity_namespace
    labels = {
      name = var.aad_pod_identity_namespace
    }
  }
}

resource "helm_release" "aad_pod_identity" {
  repository = var.aad_pod_identity_helm_repository
  chart      = var.aad_pod_identity_helm_chart_name
  version    = var.aad_pod_identity_helm_chart_version
  name       = var.aad_pod_identity_helm_release_name
  namespace  = kubernetes_namespace.aad_pod_identity.metadata[0].name

  set {
    name  = "forceNameSpaced"
    value = "true"
  }

  dynamic "set" {
    for_each = var.namespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].name"
      value = namespace.value.name
    }
  }

  dynamic "set" {
    for_each = var.namespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].namespace"
      value = namespace.value.name
    }
  }

  dynamic "set" {
    for_each = var.namespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].type"
      value = "0"
    }
  }

  dynamic "set" {
    for_each = var.namespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].resourceID"
      value = var.aad_pod_identity[namespace.value.name].id
    }
  }

  dynamic "set" {
    for_each = var.namespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].clientID"
      value = var.aad_pod_identity[namespace.value.name].client_id
    }
  }

  dynamic "set" {
    for_each = var.namespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].binding.name"
      value = namespace.value.name
    }
  }

  dynamic "set" {
    for_each = var.namespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].binding.selector"
      value = namespace.value.name
    }
  }
}
