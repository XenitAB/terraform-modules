/**
  * # Promtail
  *
  * Adds [Promtail](https://github.com/grafana/helm-charts/tree/main/charts/promtail) to a Kubernetes cluster.
  */

terraform {
  required_version = ">= 1.1.7"

  required_providers {
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

locals {
  namespace       = "promtail"
  k8s_secret_name = "xenit-proxy-certificate" #tfsec:ignore:general-secrets-no-plaintext-exposure
  aws_config = {
    key_parameter_name = "xenit-proxy-certificate-key"
    crt_parameter_name = "xenit-proxy-certificate-crt"
    role_arn           = var.aws_config.role_arn
  }
  azure_config = {
    azure_key_vault_name = var.azure_config.azure_key_vault_name
    identity             = var.azure_config.identity
    keyvault_secret_name = "xenit-proxy-certificate"
  }

}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = local.namespace
      "xkf.xenit.io/kind" = "platform"
    }
    name = local.namespace
  }
}

resource "helm_release" "promtail" {
  repository  = "https://grafana.github.io/helm-charts"
  chart       = "promtail"
  name        = "promtail"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "3.11.0"
  max_history = 3

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    provider            = var.cloud_provider
    tenant_id           = var.tenant_id
    environment         = var.environment
    cluster_name        = var.cluster_name
    namespace           = local.namespace
    excluded_namespaces = var.excluded_namespaces
    k8s_secret_name     = local.k8s_secret_name
    loki_address        = var.loki_address
    azure_config        = local.azure_config
    aws_config          = local.aws_config
  })]
}
