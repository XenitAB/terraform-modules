/**
  * # Azure AD POD Identity (AAD-POD-Identity)
  *
  * This module is used to add [`aad-pod-identity`](https://github.com/Azure/aad-pod-identity) to Kubernetes clusters (tested with AKS).
  */

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
  name      = "aad-pod-identity"
  namespace = "aad-pod-identity"
  version   = "2.0.3"
}

locals {
  values = templatefile("${path.module}/templates/values.yaml.tpl", { namespaces = var.namespaces, aad_pod_identity = var.aad_pod_identity })
}

resource "helm_release" "aad_pod_identity" {
  repository       = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart            = local.name
  name             = local.name
  version          = local.version
  namespace        = local.namespace
  create_namespace = true
  values           = [local.values]
}
