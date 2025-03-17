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
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "grafana_k8s_monitoring" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/grafana-k8s-monitoring.yaml"
  content = templatefile("${path.module}/templates/grafana-k8s-monitoring.yaml.tpl", {
    grafana_k8s_monitor_config = var.grafana_k8s_monitor_config
    cluster_name               = var.cluster_name
    tenant_id                  = azurerm_user_assigned_identity.grafana_k8s_monitor.tenant_id,
    client_id                  = azurerm_user_assigned_identity.grafana_k8s_monitor.client_id,
    key_vault_name             = var.grafana_k8s_monitor_config.azure_key_vault_name,
    exclude_namespaces         = var.grafana_k8s_monitor_config.exclude_namespaces
    tenant_name                = var.tenant_name
    cluster_id                 = var.cluster_id
  })
}


resource "git_repository_file" "monitors" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/grafana-k8s-monitoring/monitors.yaml"
  content = templatefile("${path.module}/templates/monitors.yaml.tpl", {
    falco_enabled            = var.falco_enabled,
    gatekeeper_enabled       = var.gatekeeper_enabled,
    linkerd_enabled          = var.linkerd_enabled,
    flux_enabled             = var.flux_enabled,
    aad_pod_identity_enabled = var.aad_pod_identity_enabled,
    azad_kube_proxy_enabled  = var.azad_kube_proxy_enabled,
    trivy_enabled            = var.trivy_enabled,
    grafana_agent_enabled    = var.grafana_agent_enabled,
    node_local_dns_enabled   = var.node_local_dns_enabled,
    promtail_enabled         = var.promtail_enabled,
    node_ttl_enabled         = var.node_ttl_enabled,
    spegel_enabled           = var.spegel_enabled,
    cilium_enabled           = var.cilium_enabled,
  })
}

resource "git_repository_file" "secret_provider_class" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/grafana-k8s-monitoring/secret-provider-class.yaml"
  content = templatefile("${path.module}/templates/secret-provider-class.yaml.tpl", {
    tenant_id      = azurerm_user_assigned_identity.grafana_k8s_monitor.tenant_id,
    client_id      = azurerm_user_assigned_identity.grafana_k8s_monitor.client_id,
    key_vault_name = var.grafana_k8s_monitor_config.azure_key_vault_name,
  })
}
