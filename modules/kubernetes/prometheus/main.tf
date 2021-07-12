/**
  * # Prometheus
  *
  * Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.3.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
  }
}

locals {
  namespace = "prometheus"
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

resource "helm_release" "prometheus" {
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  name       = "prometheus"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "16.12.2"
  values     = [templatefile("${path.module}/templates/values.yaml.tpl", {})]
}

resource "helm_release" "prometheus_extras" {
  depends_on = [helm_release.prometheus]

  chart     = "${path.module}/charts/prometheus-extras"
  name      = "prometheus-extras"
  namespace = kubernetes_namespace.this.metadata[0].name
  values = [templatefile("${path.module}/templates/values-extras.yaml.tpl", {
    remote_write_enabled = var.remote_write_enabled
    remote_write_url     = var.remote_write_url

    volume_claim_enabled            = var.volume_claim_enabled
    volume_claim_storage_class_name = var.volume_claim_storage_class_name
    volume_claim_size               = var.volume_claim_size

    cluster_name = var.cluster_name
    environment  = var.environment
    tenant_id    = var.tenant_id

    alertmanager_enabled = var.alertmanager_enabled

    resource_selector  = "[${join(", ", var.resource_selector)}]",
    namespace_selector = "[${join(", ", var.namespace_selector)}]",

    falco_enabled                            = var.falco_enabled
    opa_gatekeeper_enabled                   = var.opa_gatekeeper_enabled
    linkerd_enabled                          = var.linkerd_enabled
    goldpinger_enabled                       = var.goldpinger_enabled
    flux_system_enabled                      = var.flux_system_enabled
    aad_pod_identity_enabled                 = var.aad_pod_identity_enabled
    csi_secrets_store_provider_azure_enabled = var.csi_secrets_store_provider_azure_enabled
    csi_secrets_store_provider_aws_enabled   = var.csi_secrets_store_provider_aws_enabled
  })]
}
