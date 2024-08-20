/**
  * # Prometheus
  *
  * Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "3.107.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/prometheus.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

# Prometheus operator and other core monitoring components.
resource "git_repository_file" "prometheus_operator" {
  path = "platform/${var.cluster_id}/prometheus/prometheus-operator.yaml"
  content = templatefile("${path.module}/templates/prometheus-operator.yaml.tpl", {
    vpa_enabled = var.vpa_enabled,
  })
}

resource "git_repository_file" "prometheus" {
  path = "platform/${var.cluster_id}/prometheus/prometheus.yaml"
  content = templatefile("${path.module}/templates/prometheus.yaml.tpl", {
    cluster_name                    = var.cluster_name,
    environment                     = var.environment,
    region                          = var.region,
    tenant_id                       = data.azurerm_user_assigned_identity.xenit.tenant_id,
    remote_write_authenticated      = var.remote_write_authenticated,
    remote_write_url                = var.remote_write_url,
    remote_write_url_alloy          = var.remote_write_url_alloy,
    volume_claim_storage_class_name = var.volume_claim_storage_class_name,
    volume_claim_size               = var.volume_claim_size,
    resource_selector               = "[${join(", ", var.resource_selector)}]",
    namespace_selector              = "[${join(", ", var.namespace_selector)}]",
  })
}

resource "git_repository_file" "rbac" {
  path = "platform/${var.cluster_id}/prometheus/rbac.yaml"
  content = templatefile("${path.module}/templates/rbac.yaml.tpl", {
    client_id = data.azurerm_user_assigned_identity.xenit.client_id,
  })
}

resource "git_repository_file" "monitors" {
  path = "platform/${var.cluster_id}/prometheus/monitors.yaml"
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
  })
}

resource "git_repository_file" "secret_provider_class" {
  path = "platform/${var.cluster_id}/prometheus/secret-provider-class.yaml"
  content = templatefile("${path.module}/templates/secret-provider-class.yaml.tpl", {
    azure_key_vault_name = var.azure_config.azure_key_vault_name,
    client_id            = data.azurerm_user_assigned_identity.xenit.client_id,
    tenant_id            = data.azurerm_user_assigned_identity.xenit.tenant_id,
  })
}

# https://github.com/enix/x509-certificate-exporter
resource "git_repository_file" "x509_certificate_exporter" {
  path = "platform/${var.cluster_id}/prometheus/x509-certificate-exporter.yaml"
  content = templatefile("${path.module}/templates/x509-certificate-exporter.yaml.tpl", {
  })
}
