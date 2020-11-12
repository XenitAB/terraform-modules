#
# Verify functionality by running: (NOTE: You need to assign the UserAssignedIdentity something before testing)
# kubectl -n <namespace> run -it --rm azcli --image=microsoft/azure-cli --overrides='{ "apiVersion": "v1", "metadata": { "labels": { "aadpodidbinding": "<namespace>" } } }' -- /bin/bash
# az login --identity
# 

resource "kubernetes_namespace" "k8sNsAadPodIdentity" {
  metadata {
    labels = {
      name = "aad-pod-identity"
    }
    name = "aad-pod-identity"
  }
}

resource "kubernetes_config_map" "aadPodIdentityConfigMapNs" {
  for_each = {
    for ns in local.k8sNamespaces :
    ns.name => ns
  }

  metadata {
    name      = "aad-pod-identity"
    namespace = each.key
  }

  data = {
    user_assigned_identity = jsonencode(local.aadPodIdentity[each.key])
  }

  depends_on = [
    kubernetes_namespace.k8sNs
  ]
}

resource "helm_release" "aadPodIdentity" {
  name       = "aad-pod-identity"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = "aad-pod-identity"
  version    = "2.0.0"
  namespace  = "aad-pod-identity"

  set {
    name  = "forceNameSpaced"
    value = "true"
  }

  dynamic "set" {
    for_each = local.k8sNamespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].name"
      value = namespace.value.name
    }
  }

  dynamic "set" {
    for_each = local.k8sNamespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].namespace"
      value = namespace.value.name
    }
  }

  dynamic "set" {
    for_each = local.k8sNamespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].type"
      value = "0"
    }
  }

  dynamic "set" {
    for_each = local.k8sNamespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].resourceID"
      value = local.aadPodIdentity[namespace.value.name].id
    }
  }

  dynamic "set" {
    for_each = local.k8sNamespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].clientID"
      value = local.aadPodIdentity[namespace.value.name].client_id
    }
  }

  dynamic "set" {
    for_each = local.k8sNamespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].binding.name"
      value = namespace.value.name
    }
  }

  dynamic "set" {
    for_each = local.k8sNamespaces
    iterator = namespace
    content {
      name  = "azureIdentities[${namespace.key}].binding.selector"
      value = namespace.value.name
    }
  }

  depends_on = [
    kubernetes_namespace.k8sNs,
    kubernetes_namespace.k8sNsAadPodIdentity
  ]
}
