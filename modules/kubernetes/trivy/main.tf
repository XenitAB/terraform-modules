/**
  * # Trivy
  *
  * Adds [`Trivy-operator`](https://github.com/aquasecurity/trivy-operator) and
  * [`Trivy`](https://github.com/aquasecurity/trivy) to a Kubernetes clusters.
  * The modules consists of two components, trivy and trivy-operator where
  * Trivy is used as a server to store aqua security image vulnerability database.
  * Trivy-operator is used to trigger image and config scans on newly created replicasets and
  * generates a CR with a report that both admins and developers can use to improve there setup.
  *
  * [`starboard-exporter`](https://github.com/giantswarm/starboard-exporter) is used to gather
  * trivy metrics from trivy-operator CRD:s.
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

resource "kubernetes_namespace" "trivy" {
  metadata {
    labels = {
      name                = "trivy"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "trivy"
  }
}

resource "helm_release" "trivy_operator" {
  repository  = "https://aquasecurity.github.io/helm-charts/"
  chart       = "trivy-operator"
  name        = "trivy-operator"
  namespace   = kubernetes_namespace.trivy.metadata[0].name
  version     = "0.11.1-rc"
  max_history = 3
  skip_crds   = true
  values = [templatefile("${path.module}/templates/trivy-operator-values.yaml.tpl", {
    provider                = var.cloud_provider
    trivy_operator_role_arn = var.trivy_operator_role_arn
  })]
}

resource "helm_release" "starboard_exporter" {
  depends_on  = [helm_release.trivy]
  repository  = "https://giantswarm.github.io/giantswarm-catalog/"
  chart       = "starboard-exporter"
  name        = "starboard-exporter"
  version     = "0.7.1"
  namespace   = kubernetes_namespace.trivy.metadata[0].name
  max_history = 3
  values      = [file("${path.module}/templates/starboard-exporter-values.yaml")]
}

resource "helm_release" "trivy" {
  repository  = "https://aquasecurity.github.io/helm-charts/"
  chart       = "trivy"
  name        = "trivy"
  namespace   = kubernetes_namespace.trivy.metadata[0].name
  version     = "0.5.0"
  max_history = 3
  values = [templatefile("${path.module}/templates/trivy-values.yaml.tpl", {
    provider                        = var.cloud_provider
    trivy_role_arn                  = var.trivy_role_arn
    volume_claim_storage_class_name = var.volume_claim_storage_class_name
  })]
}

resource "helm_release" "trivy_extras" {
  for_each = {
    for s in ["trivy_extras"] :
    s => s
    if var.cloud_provider == "azure"
  }

  chart       = "${path.module}/charts/trivy-extras"
  name        = "trivy-extras"
  namespace   = kubernetes_namespace.trivy.metadata[0].name
  max_history = 3

  set {
    name  = "resourceID"
    value = var.resource_id
  }

  set {
    name  = "clientID"
    value = var.client_id
  }
}
