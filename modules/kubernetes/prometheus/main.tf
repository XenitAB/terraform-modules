/**
  * # Prometheus
  *
  * Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.
  * If you are running on AWS we also install [Metrics server](https://aws.amazon.com/premiumsupport/knowledge-center/eks-metrics-server/)
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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
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

data "helm_template" "prometheus" {
  repository   = "https://prometheus-community.github.io/helm-charts"
  chart        = "kube-prometheus-stack"
  name         = "prometheus"
  version      = "30.0.0"
  include_crds = true
}

data "kubectl_file_documents" "prometheus" {
  content = data.helm_template.prometheus.manifest
}

resource "kubectl_manifest" "prometheus" {
  for_each = {
    for k, v in data.kubectl_file_documents.prometheus.manifests :
    k => v
    if can(regex("^/apis/apiextensions.k8s.io/v1/customresourcedefinitions/", k))
  }
  server_side_apply = true
  apply_only        = true
  yaml_body         = each.value
}

# Prometheus operator and other core monitoring components.
resource "helm_release" "prometheus" {
  depends_on = [kubectl_manifest.prometheus]

  repository  = "https://prometheus-community.github.io/helm-charts"
  chart       = "kube-prometheus-stack"
  name        = "prometheus"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "30.0.0"
  max_history = 3
  skip_crds   = true
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    vpa_enabled = var.vpa_enabled,
  })]
}

# EKS will not install metrics server out of the box so it has to be added.
resource "helm_release" "metrics_server" {
  for_each = {
    for s in ["metrics-server"] :
    s => s
    if var.cloud_provider == "aws"
  }

  repository  = "https://charts.bitnami.com/bitnami"
  chart       = "metrics-server"
  name        = "metrics-server"
  namespace   = "kube-system"
  version     = "5.10.5"
  max_history = 3
  values      = [templatefile("${path.module}/templates/values-metrics-server.yaml.tpl", {})]
}

# Prometheus declaration and monitors for all of the platform applications.
resource "helm_release" "prometheus_extras" {
  depends_on = [helm_release.prometheus]

  chart       = "${path.module}/charts/prometheus-extras"
  name        = "prometheus-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  values = [templatefile("${path.module}/templates/values-extras.yaml.tpl", {
    cloud_provider = var.cloud_provider
    azure_config   = var.azure_config
    aws_config     = var.aws_config

    cluster_name = var.cluster_name
    environment  = var.environment
    tenant_id    = var.tenant_id

    remote_write_authenticated = var.remote_write_authenticated
    remote_write_url           = var.remote_write_url

    volume_claim_storage_class_name = var.volume_claim_storage_class_name
    volume_claim_size               = var.volume_claim_size

    resource_selector  = "[${join(", ", var.resource_selector)}]",
    namespace_selector = "[${join(", ", var.namespace_selector)}]",

    falco_enabled                            = var.falco_enabled
    opa_gatekeeper_enabled                   = var.opa_gatekeeper_enabled
    linkerd_enabled                          = var.linkerd_enabled
    flux_enabled                             = var.flux_enabled
    aad_pod_identity_enabled                 = var.aad_pod_identity_enabled
    csi_secrets_store_provider_azure_enabled = var.csi_secrets_store_provider_azure_enabled
    csi_secrets_store_provider_aws_enabled   = var.csi_secrets_store_provider_aws_enabled
    azad_kube_proxy_enabled                  = var.azad_kube_proxy_enabled
    starboard_enabled                        = var.starboard_enabled
    grafana_agent_enabled                    = var.grafana_agent_enabled
    node_local_dns_enabled                   = var.node_local_dns_enabled
    promtail_enabled                         = var.promtail_enabled
  })]
}
