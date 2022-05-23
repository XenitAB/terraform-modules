/**
  * # Starboard
  *
  * Adds [`Starboard`](https://github.com/aquasecurity/starboard) and
  * [`Trivy`](https://github.com/aquasecurity/trivy) to a Kubernetes clusters.
  * The modules consists of two components, trivy and starboard where
  * Trivy is used as a server to store aqua security image vulnerability database.
  * Staboard is used to trigger image and config scans on newly created replicasets and
  * generates a CR with a report that both admins and developers can use to improve there setup.
  *
  * [`starboard-exporter`](https://github.com/giantswarm/starboard-exporter) is used to gather
  * trivy metrics from starboard CRD:s.
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

resource "kubernetes_namespace" "starboard" {
  metadata {
    labels = {
      name                = "starboard-operator"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "starboard-operator"
  }
}

resource "helm_release" "starboard" {
  repository  = "https://aquasecurity.github.io/helm-charts/"
  chart       = "starboard-operator"
  name        = "starboard-operator"
  namespace   = kubernetes_namespace.starboard.metadata[0].name
  version     = "0.9.1"
  max_history = 3
  values = [templatefile("${path.module}/templates/starboard-values.yaml.tpl", {
    provider           = var.cloud_provider
    starboard_role_arn = var.starboard_role_arn
  })]
}

resource "helm_release" "starboard_exporter" {
  depends_on  = [helm_release.starboard]
  repository  = "https://giantswarm.github.io/giantswarm-catalog/"
  chart       = "starboard-exporter"
  name        = "starboard-exporter"
  version     = "0.1.4"
  namespace   = kubernetes_namespace.starboard.metadata[0].name
  max_history = 3
  values      = [file("${path.module}/templates/starboard-exporter-values.yaml")]
}

resource "helm_release" "trivy" {
  repository  = "https://aquasecurity.github.io/helm-charts/"
  chart       = "trivy"
  name        = "trivy"
  namespace   = kubernetes_namespace.starboard.metadata[0].name
  version     = "0.4.12"
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
  namespace   = kubernetes_namespace.starboard.metadata[0].name
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
