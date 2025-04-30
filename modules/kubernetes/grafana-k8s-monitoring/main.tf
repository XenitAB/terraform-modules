/**
  * # grafana-k8s-monitoring
  *
  * Adds [grafana-k8s-monitoring](https://github.com/grafana/k8s-monitoring-helm/tree/main/charts/k8s-monitoring) to a Kubernetes cluster.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
  }
}

resource "git_repository_file" "grafana_k8s_monitoring_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "grafana_k8s_monitoring_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "grafana_k8s_monitoring_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/grafana-k8s-monitoring-app.yaml"
  content = templatefile("${path.module}/templates/grafana-k8s-monitoring-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "grafana_k8s_monitoring" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring/templates/grafana-k8s-monitoring.yaml"
  content = templatefile("${path.module}/templates/grafana-k8s-monitoring.yaml.tpl", {
    tenant_name                = var.tenant_name
    environment                = var.environment
    project                    = var.fleet_infra_config.argocd_project_name
    server                     = var.fleet_infra_config.k8s_api_server_url
    grafana_k8s_monitor_config = var.grafana_k8s_monitor_config
    cluster_name               = var.cluster_name
    tenant_id                  = azurerm_user_assigned_identity.grafana_k8s_monitor.tenant_id
    client_id                  = azurerm_user_assigned_identity.grafana_k8s_monitor.client_id
    key_vault_name             = var.grafana_k8s_monitor_config.azure_key_vault_name
    exclude_namespaces         = var.grafana_k8s_monitor_config.exclude_namespaces
  })
}

resource "git_repository_file" "grafana_k8s_monitoring_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring/templates/grafana-k8s-monitoring-extras.yaml"
  content = templatefile("${path.module}/templates/grafana-k8s-monitoring-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "monitors" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring/manifests/monitors.yaml"
  content = templatefile("${path.module}/templates/monitors.yaml.tpl", {
    falco_enabled            = var.falco_enabled
    gatekeeper_enabled       = var.gatekeeper_enabled
    linkerd_enabled          = var.linkerd_enabled
    aad_pod_identity_enabled = var.aad_pod_identity_enabled
    azad_kube_proxy_enabled  = var.azad_kube_proxy_enabled
    trivy_enabled            = var.trivy_enabled
    grafana_agent_enabled    = var.grafana_agent_enabled
    node_local_dns_enabled   = var.node_local_dns_enabled
    promtail_enabled         = var.promtail_enabled
    node_ttl_enabled         = var.node_ttl_enabled
    spegel_enabled           = var.spegel_enabled
    cilium_enabled           = var.cilium_enabled
    azure_metrics_enabled    = var.azure_metrics_enabled
    subscription_id          = var.subscription_id
  })
}

resource "git_repository_file" "secret_provider_class" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring/manifests/secret-provider-class.yaml"
  content = templatefile("${path.module}/templates/secret-provider-class.yaml.tpl", {
    tenant_id      = azurerm_user_assigned_identity.grafana_k8s_monitor.tenant_id
    client_id      = azurerm_user_assigned_identity.grafana_k8s_monitor.client_id
    key_vault_name = var.grafana_k8s_monitor_config.azure_key_vault_name
  })
}
