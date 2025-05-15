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
      version = ">=0.0.4"
    }
  }
}

resource "git_repository_file" "gatekeeper_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/gatekeeper/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "gatekeeper_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/gatekeeper/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "gatekeeper_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/gatekeeper-app.yaml"
  content = templatefile("${path.module}/templates/gatekeeper-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "gatekeeper" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/gatekeeper/templates/gatekeeper.yaml"
  content = templatefile("${path.module}/templates/gatekeeper.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "gatekeeper_templates" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/gatekeeper/templates/gatekeeper-templates.yaml"
  content = templatefile("${path.module}/templates/gatekeeper-templates.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "gatekeeper_config" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/gatekeeper/templates/gatekeeper-config.yaml"
  content = templatefile("${path.module}/templates/gatekeeper-config.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "gatekeeper_template_manifest" {
  path    = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/gatekeeper/manifests/templates/gatekeeper-templates.yaml"
  content = templatefile("${path.module}/templates/gatekeeper-constraint-templates.yaml.tpl", {})
}

resource "git_repository_file" "gatekeeper_config_manifest" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/gatekeeper/manifests/config/gatekeeper-config.yaml"
  content = templatefile("${path.module}/templates/gatekeeper-config-manifests.yaml.tpl", {
    exclude_namespaces             = var.exclude_namespaces
    azure_service_operator_enabled = var.azure_service_operator_enabled
    mirrord_enabled                = var.mirrord_enabled
    telepresence_enabled           = var.telepresence_enabled
  })
}
