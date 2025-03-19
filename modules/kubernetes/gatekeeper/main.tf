/**
  * # Gatekeeper
  *
  * Adds [`gatekeeper`](https://github.com/open-policy-agent/gatekeeper) to a Kubernetes clusters.
  *
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

resource "git_repository_file" "gatekeeper" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/gatekeeper.yaml"
  content = templatefile("${path.module}/templates/gatekeeper.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "gatekeeper_template" {
  path    = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/gatekeeper/gatekeeper-template.yaml"
  content = templatefile("${path.module}/templates/gatekeeper-template.yaml.tpl", {})
}

resource "git_repository_file" "gatekeeper_config" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/gatekeeper/gatekeeper-config.yaml"
  content = templatefile("${path.module}/templates/gatekeeper-config.yaml.tpl", {
    exclude_namespaces             = var.exclude_namespaces
    azure_service_operator_enabled = var.azure_service_operator_enabled
    mirrord_enabled                = var.mirrord_enabled
    telepresence_enabled           = var.telepresence_enabled
  })
}
