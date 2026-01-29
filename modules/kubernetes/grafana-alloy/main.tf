terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.57.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
  }
}

resource "git_repository_file" "grafana_alloy_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-alloy/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "grafana_alloy_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-alloy/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "grafana_alloy_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/grafana-alloy-app.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "grafana_alloy" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-alloy/templates/grafana-alloy.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy.yaml.tpl", {
    tenant_name  = var.tenant_name
    environment  = var.environment
    cluster_id   = var.cluster_id
    project      = var.fleet_infra_config.argocd_project_name
    server       = var.fleet_infra_config.k8s_api_server_url
    repo_url     = var.fleet_infra_config.git_repo_url
    azure_config = var.azure_config
    client_id    = data.azurerm_user_assigned_identity.xenit.client_id
    tenant_id    = data.azurerm_user_assigned_identity.xenit.tenant_id
  })
}

resource "git_repository_file" "kube_state_metrics" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-alloy/templates/kube-state-metrics.yaml"
  content = templatefile("${path.module}/templates/kube-state-metrics.yaml.tpl", {
    tenant_name    = var.tenant_name
    environment    = var.environment
    project        = var.fleet_infra_config.argocd_project_name
    server         = var.fleet_infra_config.k8s_api_server_url
    namespaces_csv = join(",", compact(concat(var.namespace_include, var.extra_namespaces)))
  })
}

resource "git_repository_file" "grafana_alloy_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-alloy/templates/grafana-alloy-extras.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "grafana_alloy_manifests" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-alloy/manifests/grafana-alloy-extras.yaml"
  content = templatefile("${path.module}/templates/grafana-alloy-manifests.yaml.tpl", {
    credentials_secret_name     = "grafana-alloy-credentials"
    remote_write_metrics_url    = var.remote_write_urls.metrics
    remote_write_logs_url       = var.remote_write_urls.logs
    remote_write_traces_url     = var.remote_write_urls.traces
    environment                 = var.environment
    cluster_name                = var.cluster_name
    ingress_nginx_observability = tostring(contains(var.extra_namespaces, "ingress-nginx"))
    include_kubelet_metrics     = var.include_kubelet_metrics
    kubelet_metrics_namespaces  = join("|", compact(concat(var.namespace_include, var.extra_namespaces)))
    namespace_include           = var.namespace_include
    azure_config                = var.azure_config
    client_id                   = data.azurerm_user_assigned_identity.xenit.client_id
    tenant_id                   = data.azurerm_user_assigned_identity.xenit.tenant_id
  })
}
