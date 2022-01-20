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
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
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

resource "kubernetes_namespace" "trivy" {
  metadata {
    labels = {
      name                = "trivy"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "trivy"
  }
}

resource "helm_release" "starboard" {
  repository  = "https://aquasecurity.github.io/helm-charts/"
  chart       = "starboard-operator"
  name        = "starboard-operator"
  namespace   = kubernetes_namespace.starboard.metadata[0].name
  version     = "0.9.0"
  max_history = 3
  values = [templatefile("${path.module}/templates/starboard-values.yaml.tpl", {
    provider = var.cloud_provider
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
  namespace   = kubernetes_namespace.trivy.metadata[0].name
  version     = "0.4.9"
  max_history = 3
}
