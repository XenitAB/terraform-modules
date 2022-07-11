terraform {
  required_version = ">= 1.1.7"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
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
  # Validate makes Helm run in client only mode. Fixes broken Kubernetes API version validation.
  # https://github.com/hashicorp/terraform-provider-helm/blob/362ef45c3bc4eb8b7451396a2b8712d745281bc6/helm/data_template.go#L455
  validate = true

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
