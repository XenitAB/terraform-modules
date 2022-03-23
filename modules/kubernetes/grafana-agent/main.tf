/**
 * # Grafana Agent
 * Adds [`grafana-agent`](https://grafana.com/docs/agent/latest/) (the operator) to a Kubernetes clusters.
 *
*/

terraform {
  required_version = "0.15.3"

  required_providers {
    azurerm = {
      version = "2.99.0"
      source  = "hashicorp/azurerm"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
  }
}


resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "grafana-agent"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "grafana-agent"
  }
}

data "azurerm_key_vault" "core" {
  name                = var.azure_config.azure_key_vault_name
  resource_group_name = var.azure_config.resource_group_name
}

data "azurerm_key_vault_certificate_data" "xenit_proxy" {
  name         = "xenit-proxy-certificate"
  key_vault_id = data.azurerm_key_vault.core.id
}

locals {
  extras_values = templatefile("${path.module}/templates/extras-values.yaml.tpl", {
    environment     = var.environment
    cluster_name    = var.cluster_name
    cloud_provider  = var.cloud_provider
    remote_logs_url = var.remote_logs_url
    azure_config    = var.azure_config
    client_key      = data.azurerm_key_vault_certificate_data.xenit_proxy.key
    client_cert     = data.azurerm_key_vault_certificate_data.xenit_proxy.pem
  })

  operator_values = templatefile("${path.module}/templates/operator-values.yaml.tpl", {
    namespace = kubernetes_namespace.this.metadata[0].name
  })
}

resource "helm_release" "grafana_agent_operator" {
  repository  = "https://grafana.github.io/helm-charts"
  chart       = "grafana-agent-operator"
  name        = "grafana-agent-operator"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "0.1.6"
  max_history = 3

  values = [local.operator_values]
}

resource "helm_release" "grafana_agent_extras" {
  depends_on = [helm_release.grafana_agent_operator]

  chart       = "${path.module}/charts/grafana-agent-extras"
  name        = "grafana-agent-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  values      = [local.extras_values]
}
