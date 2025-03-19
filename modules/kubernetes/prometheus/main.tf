/**
  * # Prometheus
  *
  * Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.
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

# Prometheus operator and other core monitoring components.
resource "git_repository_file" "prometheus_operator" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/kube-prometheus-stack.yaml"
  content = templatefile("${path.module}/templates/kube-prometheus-stack.yaml.tpl", {
    vpa_enabled = var.vpa_enabled
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "prometheus" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/kube-prometheus-stack/prometheus.yaml"
  content = templatefile("${path.module}/templates/prometheus.yaml.tpl", {
    cluster_name                    = var.cluster_name
    environment                     = var.environment
    region                          = var.region
    tenant_id                       = data.azurerm_user_assigned_identity.xenit.tenant_id
    remote_write_authenticated      = var.remote_write_authenticated
    remote_write_url                = var.remote_write_url
    volume_claim_storage_class_name = var.volume_claim_storage_class_name
    volume_claim_size               = var.volume_claim_size
    resource_selector               = "[${join(", ", var.resource_selector)}]"
    namespace_selector              = "[${join(", ", var.namespace_selector)}]"
    tenant_name                     = var.tenant_name
    cluster_id                      = var.cluster_id
  })
}

resource "git_repository_file" "rbac" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/kube-prometheus-stack/rbac.yaml"
  content = templatefile("${path.module}/templates/rbac.yaml.tpl", {
    client_id = data.azurerm_user_assigned_identity.xenit.client_id
  })
}

resource "git_repository_file" "monitors" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/kube-prometheus-stack/monitors.yaml"
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
  })
}

resource "git_repository_file" "x509_certificate_exporter" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/x509-certificate-exporter.yaml"
  content = templatefile("${path.module}/templates/x509-certificate-exporter.yaml.tpl", {
    project = var.fleet_infra_config.argocd_project_name
    server  = var.fleet_infra_config.k8s_api_server_url
  })
}
