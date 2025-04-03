/**
  * # Azure AD POD Identity (AAD-POD-Identity)
  *
  * This module is used to add [`aad-pod-identity`](https://github.com/Azure/aad-pod-identity) to Kubernetes clusters (tested with AKS).
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "aad_pod_identity" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/aad-pod-identity.yaml"
  content = templatefile("${path.module}/templates/aad-pod-identity.yaml.tpl", {
    namespaces       = var.namespaces,
    aad_pod_identity = var.aad_pod_identity
    tenant_name      = var.tenant_name
    environment      = var.environment
    project          = var.fleet_infra_config.argocd_project_name
    server           = var.fleet_infra_config.k8s_api_server_url
  })
}
