terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = ">= 0.0.4"
    }
  }
}

resource "git_repository_file" "node_sysctls_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/node-sysctls.yaml"

  content = templatefile("${path.module}/templates/node-sysctls.yaml.tpl", {
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
    server      = var.fleet_infra_config.k8s_api_server_url
    cluster_id  = var.cluster_id
    tenant_name = var.tenant_name
    environment = var.environment
  })
}

resource "git_repository_file" "node_sysctls_manifest" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/node-sysctls/node-sysctls.yaml"

  content = templatefile("${path.module}/templates/node-sysctls-manifest.yaml.tpl", {
    vm_max_map_count = var.vm_max_map_count
    node_selector    = var.node_selector
    tolerations      = var.tolerations
  })
}
