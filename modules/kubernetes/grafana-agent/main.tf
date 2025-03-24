/**
 * # Grafana agent operator
 * 
 * Adds [`grafana-agent`](https://grafana.com/docs/agent/latest/) (the operator) amd
 * [`kube-state-metrics`](https://github.com/kubernetes/kube-state-metrics) to a Kubernetes clusters.
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

resource "git_repository_file" "grafana_agent_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-agent/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "grafana_agent_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-agent/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "grafana_agent_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/grafana-agent-app.yaml"
  content = templatefile("${path.module}/templates/grafana-agent-app.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "grafana_agent" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-agent/templates/grafana-agent.yaml"
  content = templatefile("${path.module}/templates/grafana-agent.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "kube_state_metrics" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-agent/templates/kube-state-metrics.yaml"
  content = templatefile("${path.module}/templates/kube-state-metrics.yaml.tpl", {
    project        = var.fleet_infra_config.argocd_project_name
    server         = var.fleet_infra_config.k8s_api_server_url
    namespaces_csv = join(",", compact(concat(var.namespace_include, var.extra_namespaces)))
  })
}

resource "git_repository_file" "grafana_agent_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-agent/templates/grafana-agent-extras.yaml"
  content = templatefile("${path.module}/templates/grafana-agent-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "grafana_agent_manifests" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/grafana-agent/grafana-agent-extras.yaml"
  content = templatefile("${path.module}/templates/grafana-agent-manifests.yaml.tpl", {
    credentials_secret_name     = "grafana-agent-credentials"
    remote_write_metrics_url    = var.remote_write_urls.metrics
    remote_write_logs_url       = var.remote_write_urls.logs
    remote_write_traces_url     = var.remote_write_urls.traces
    environment                 = var.environment
    cluster_name                = var.cluster_name
    ingress_nginx_observability = tostring(contains(var.extra_namespaces, "ingress-nginx"))
    include_kubelet_metrics     = var.include_kubelet_metrics
    kubelet_metrics_namespaces  = join("|", compact(concat(var.namespace_include, var.extra_namespaces)))
    metrics_username            = base64encode(var.credentials.metrics_username)
    metrics_password            = base64encode(var.credentials.metrics_password)
    logs_username               = base64encode(var.credentials.logs_username)
    logs_password               = base64encode(var.credentials.logs_password)
    traces_username             = base64encode(var.credentials.traces_username)
    traces_password             = base64encode(var.credentials.traces_password)
  })
}