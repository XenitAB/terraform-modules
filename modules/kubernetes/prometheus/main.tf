/**
  * # Prometheus
  *
  * Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.
  * If you are running on AWS we also install [Metrics server](https://aws.amazon.com/premiumsupport/knowledge-center/eks-metrics-server/)
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "prometheus"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "prometheus"
  }
}

# Prometheus operator and other core monitoring components.
resource "helm_release" "prometheus" {
  repository  = "https://prometheus-community.github.io/helm-charts"
  chart       = "kube-prometheus-stack"
  name        = "prometheus"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "42.1.1"
  max_history = 3
  skip_crds   = true
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    vpa_enabled = var.vpa_enabled,
  })]

  # This is needed while upgrading past v40.x.x as it contains a label change which requires replacing the Node Exporter Daemon Set
  # Should be removed in the future when not required.
  # https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#from-39x-to-40x
  force_update = true
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
  version     = "6.2.4"
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
    region       = var.region
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
    trivy_enabled                            = var.trivy_enabled
    grafana_agent_enabled                    = var.grafana_agent_enabled
    node_local_dns_enabled                   = var.node_local_dns_enabled
    promtail_enabled                         = var.promtail_enabled
    node_ttl_enabled                         = var.node_ttl_enabled
  })]
}

# https://github.com/enix/x509-certificate-exporter
resource "helm_release" "x509_certificate_exporter" {
  repository  = "https://charts.enix.io"
  chart       = "x509-certificate-exporter"
  name        = "x509-certificate-exporter"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "3.6.0"
  max_history = 3
  values = [templatefile("${path.module}/templates/values-x509.yaml.tpl", {
    prometheus_namespace = kubernetes_namespace.this.metadata[0].name,
  })]
}
