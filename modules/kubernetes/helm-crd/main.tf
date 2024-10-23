terraform {
  required_version = ">= 1.3.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

data "helm_template" "this" {
  repository   = var.chart_repository
  chart        = var.chart_name
  name         = var.chart_name
  version      = var.chart_version
  include_crds = true
  api_versions = ["apiextensions.k8s.io/v1/CustomResourceDefinition"]
  kube_version = "1.29.3"

  dynamic "set" {
    for_each = var.values

    content {
      name  = set.key
      value = set.value
    }
  }
}

data "kubectl_file_documents" "this" {
  content = data.helm_template.this.manifest
}

resource "kubectl_manifest" "this" {
  for_each = {
    for k, v in data.kubectl_file_documents.this.manifests :
    k => v
    if can(regex("^/apis/apiextensions.k8s.io/v1/customresourcedefinitions/", k))
  }
  server_side_apply = true
  apply_only        = true
  yaml_body         = each.value
}
