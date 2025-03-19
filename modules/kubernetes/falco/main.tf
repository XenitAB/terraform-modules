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
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "falco" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/falco.yaml"
  content = templatefile("${path.module}/templates/falco.yaml.tpl", {
    cilium_enabled = var.cilium_enabled
    project        = var.fleet_infra_config.argocd_project_name
    server         = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "falco_exporter" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/falco-exporter.yaml"
  content = templatefile("${path.module}/templates/falco-exporter.yaml.tpl", {
    project = var.fleet_infra_config.argocd_project_name
    server  = var.fleet_infra_config.k8s_api_server_url
  })
}
