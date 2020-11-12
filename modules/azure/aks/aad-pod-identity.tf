#resource "kubernetes_namespace" "aad_pod_identity" {
#  metadata {
#    name = "aad-pod-identity"
#    labels = {
#      name = "aad-pod-identity"
#    }
#  }
#}
#
#resource "kubernetes_config_map" "aad_pod_identity" {
#  depends_on = [kubernetes_namespace.k8sNs]
#  for_each = {
#    for ns in var.kubernetes_namespaces :
#    ns.name => ns
#  }
#
#  metadata {
#    name      = "aad-pod-identity"
#    namespace = each.key
#  }
#
#  data = {
#    user_assigned_identity = jsonencode(local.aadPodIdentity[each.key])
#  }
#}
#
#resource "helm_release" "aad_pod_identity" {
#  depends_on = [kubernetes_namespace.k8sNs]
#
#  name       = "aad-pod-identity"
#  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
#  chart      = "aad-pod-identity"
#  version    = "2.0.0"
#  namespace  = kubernetes_namespace.aad_pod_identity.name
#
#  set {
#    name  = "forceNameSpaced"
#    value = "true"
#  }
#
#  dynamic "set" {
#    for_each = local.k8sNamespaces
#    iterator = namespace
#    content {
#      name  = "azureIdentities[${namespace.key}].name"
#      value = namespace.value.name
#    }
#  }
#
#  dynamic "set" {
#    for_each = var.kubernetes_namespaces
#    iterator = namespace
#    content {
#      name  = "azureIdentities[${namespace.key}].namespace"
#      value = namespace.value.name
#    }
#  }
#
#  dynamic "set" {
#    for_each = var.kubernetes_namespaces
#    iterator = namespace
#    content {
#      name  = "azureIdentities[${namespace.key}].type"
#      value = "0"
#    }
#  }
#
#  dynamic "set" {
#    for_each = var.kubernetes_namespaces
#    iterator = namespace
#    content {
#      name  = "azureIdentities[${namespace.key}].resourceID"
#      value = local.aadPodIdentity[namespace.value.name].id
#    }
#  }
#
#  dynamic "set" {
#    for_each = var.kubernetes_namespaces
#    iterator = namespace
#    content {
#      name  = "azureIdentities[${namespace.key}].clientID"
#      value = local.aadPodIdentity[namespace.value.name].client_id
#    }
#  }
#
#  dynamic "set" {
#    for_each = var.kubernetes_namespaces
#    iterator = namespace
#    content {
#      name  = "azureIdentities[${namespace.key}].binding.name"
#      value = namespace.value.name
#    }
#  }
#
#  dynamic "set" {
#    for_each = var.kubernetes_namespaces
#    iterator = namespace
#    content {
#      name  = "azureIdentities[${namespace.key}].binding.selector"
#      value = namespace.value.name
#    }
#  }
#}
