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
  for_each = {
    for s in ["node-sysctls"] :
    s => s
    if length(var.node_sysctls_config) > 0
  }

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

resource "git_repository_file" "node_sysctls_namespace" {
  for_each = {
    for s in ["node-sysctls"] :
    s => s
    if length(var.node_sysctls_config) > 0
  }

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/node-sysctls/manifests/namespace.yaml"

  content = templatefile("${path.module}/templates/node-sysctls-namespace.yaml.tpl", {})
}

resource "git_repository_file" "node_sysctls_manifest" {
  for_each = {
    for profile in var.node_sysctls_config :
    profile.name => profile
  }

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/node-sysctls/manifests/node-sysctls-${each.key}.yaml"

  content = templatefile("${path.module}/templates/node-sysctls-manifest.yaml.tpl", {
    name          = each.value.name
    sysctls       = each.value.sysctls
    node_selector = each.value.node_selector
    tolerations   = each.value.tolerations
  })
}
