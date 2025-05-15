/**
  * # Falco
  *
  * Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.
  * The modules consists of two components, the main Falco driver and Falco exporter
  * to expose event metrics.
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

resource "git_repository_file" "falco_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/falco/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "falco_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/falco/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "falco_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/falco-app.yaml"
  content = templatefile("${path.module}/templates/falco-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "falco" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/falco/templates/falco.yaml"
  content = templatefile("${path.module}/templates/falco.yaml.tpl", {
    cilium_enabled = var.cilium_enabled
    tenant_name    = var.tenant_name
    environment    = var.environment
    project        = var.fleet_infra_config.argocd_project_name
    server         = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "falco_exporter" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/falco/templates/falco-exporter.yaml"
  content = templatefile("${path.module}/templates/falco-exporter.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}
