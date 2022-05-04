/**
  * # Vertical Pod Autoscaler/
  *
  * Adds [`VPA`](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) using
  * [`FairwindsOps`](https://github.com/FairwindsOps/charts/tree/master/stable/vpa) helm chart to deploy VPA.
  * VPA recommender is the only feature enabled, it's not possible to auto update deployments from VPA.
  * [`Goldilocks`](https://github.com/FairwindsOps/charts/tree/master/stable/goldilocks) is used to auto create
  * VPA config to all kinds of workloads. This will help us generate metrics for our tenants and the platform.
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

resource "kubernetes_namespace" "vpa" {
  metadata {
    labels = {
      name                = "vpa"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "vpa"
  }
}

data "helm_template" "vpa" {
  repository   = "https://charts.fairwinds.com/stable"
  chart        = "goldilocks"
  name         = "goldilocks"
  version      = "5.1.0"
  include_crds = true
}

data "kubectl_file_documents" "vpa" {
  content = data.helm_template.vpa.manifest
}

resource "kubectl_manifest" "vpa" {
  for_each = {
    for k, v in data.kubectl_file_documents.vpa.manifests :
    k => v
    if can(regex("^/apis/apiextensions.k8s.io/v1/customresourcedefinitions/", k))
  }
  server_side_apply = true
  apply_only        = true
  yaml_body         = each.value
}

resource "helm_release" "vpa" {
  depends_on = [kubectl_manifest.vpa]

  repository  = "https://charts.fairwinds.com/stable"
  chart       = "vpa"
  name        = "vpa"
  namespace   = kubernetes_namespace.vpa.metadata[0].name
  version     = "0.5.0"
  max_history = 3
  skip_crds   = true
  values      = [templatefile("${path.module}/templates/vpa-values.yaml.tpl", {})]
}

resource "helm_release" "goldilocks" {
  depends_on = [kubectl_manifest.vpa]

  repository  = "https://charts.fairwinds.com/stable"
  chart       = "goldilocks"
  name        = "goldilocks"
  namespace   = kubernetes_namespace.vpa.metadata[0].name
  version     = "5.1.0"
  max_history = 3
  values      = [templatefile("${path.module}/templates/goldilocks-values.yaml.tpl", {})]
}
