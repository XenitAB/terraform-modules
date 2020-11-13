resource "kubernetes_namespace" "aad_pod_identity" {
  metadata {
    name = "aad-pod-identity"
    labels = {
      name = "aad-pod-identity"
    }
  }
}

resource "helm_release" "aad_pod_identity" {
  depends_on = [kubernetes_namespace.k8sNs]

  name       = "aad-pod-identity"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = "aad-pod-identity"
  version    = "2.0.0"
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
