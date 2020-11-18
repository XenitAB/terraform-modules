# Module requirements
terraform {
  required_version = "0.13.5"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

locals {
  name = "aad-pod-identity"
  namespace = "aad-pod-identity"
  version = "2.0.3"
}

resource "helm_release" "aad_pod_identity" {
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = local.name
  name       = local.name
  version    = local.version
  namespace = local.namespace
  create_namespace = true

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
