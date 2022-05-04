/**
  * # Azure AD POD Identity (AAD-POD-Identity)
  *
  * This module is used to add [`aad-pod-identity`](https://github.com/Azure/aad-pod-identity) to Kubernetes clusters (tested with AKS).
  */

terraform {
  required_version = ">= 1.1.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "aad-pod-identity"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "aad-pod-identity"
  }
}

data "helm_template" "aad_pod_identity" {
  repository   = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart        = "aad-pod-identity"
  name         = "aad-pod-identity"
  version      = "4.0.0"
  include_crds = true
}

data "kubectl_file_documents" "aad_pod_identity" {
  content = data.helm_template.aad_pod_identity.manifest
}

resource "kubectl_manifest" "aad_pod_identity" {
  for_each = {
    for k, v in data.kubectl_file_documents.aad_pod_identity.manifests :
    k => v
    if can(regex("^/apis/apiextensions.k8s.io/v1/customresourcedefinitions/", k))
  }
  server_side_apply = true
  apply_only        = true
  yaml_body         = each.value
}

#tf-latest-version:ignore
resource "helm_release" "aad_pod_identity" {
  depends_on = [kubectl_manifest.aad_pod_identity]

  repository  = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart       = "aad-pod-identity"
  name        = "aad-pod-identity"
  version     = "4.0.0"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  skip_crds   = true
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    namespaces       = var.namespaces,
    aad_pod_identity = var.aad_pod_identity
  })]
}
