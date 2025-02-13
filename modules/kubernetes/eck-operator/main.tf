/**
  * # grafana-k8s-monitoring
  *
  * Adds [grafana-k8s-monitoring](https://github.com/grafana/k8s-monitoring-helm/tree/main/charts/k8s-monitoring) to a Kubernetes cluster.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.7.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "eck-system"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "eck-operator"
  }
}

resource "git_repository_file" "kustomization" {
  path       = "clusters/${var.cluster_id}/eck-operator.yaml.yaml"
  depends_on = [kubernetes_namespace.this]
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id,
  })
}

resource "git_repository_file" "eck_operator" {
  path = "platform/${var.cluster_id}/eck-operator.yaml/eck-operator.yaml"
  content = templatefile("${path.module}/templates/eck-operator.yaml.tpl", {
    eck_managed_namespaces = var.eck_managed_namespaces
  })
}
