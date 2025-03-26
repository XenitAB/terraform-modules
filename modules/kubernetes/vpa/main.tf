/**
  * # Vertical Pod Autoscaler/
  *
  * Adds [`VPA`](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) using
  * [`FairwindsOps`](https://github.com/FairwindsOps/charts/tree/master/stable/vpa) helm chart to deploy VPA.
  * VPA recommender is the only feature enabled, it's not possible to auto update deployments from VPA.
  * [`Goldilocks`](https://github.com/FairwindsOps/charts/tree/master/stable/goldilocks) is used to auto create
  * VPA config to all kinds of workloads. This will help us generate metrics for our tenants and the platform.
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

resource "git_repository_file" "vpa_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/vpa/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "vpa_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/vpa/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "vpa_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/vpa-app.yaml"
  content = templatefile("${path.module}/templates/vpa-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "vpa" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/vpa/templates/vpa.yaml"
  content = templatefile("${path.module}/templates/vpa.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "goldilocks" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/vpa/templates/goldilocks.yaml"
  content = templatefile("${path.module}/templates/goldilocks.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}
