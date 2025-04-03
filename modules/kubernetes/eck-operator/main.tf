/**
  * # grafana-k8s-monitoring
  *
  * Adds [grafana-k8s-monitoring](https://github.com/grafana/k8s-monitoring-helm/tree/main/charts/k8s-monitoring) to a Kubernetes cluster.
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

resource "git_repository_file" "eck_operator" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/eck-operator.yaml"
  content = templatefile("${path.module}/templates/eck-operator.yaml.tpl", {
    eck_managed_namespaces = var.eck_managed_namespaces
    tenant_name            = var.tenant_name
    environment            = var.environment
    project                = var.fleet_infra_config.argocd_project_name
    server                 = var.fleet_infra_config.k8s_api_server_url
  })
}
