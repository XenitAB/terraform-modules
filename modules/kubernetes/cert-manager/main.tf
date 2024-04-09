/**
  * # Certificate manager (cert-manager)
  *
  * This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/cert-manager.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id
  })
}

<<<<<<< HEAD
resource "git_repository_file" "cert_manager" {
  path = "platform/${var.cluster_id}/cert-manager/cert-manager.yaml"
  content = templatefile("${path.module}/templates/cert-manager.yaml.tpl", {
    notification_email = var.notification_email,
    acme_server        = var.acme_server,
    azure_config       = var.azure_config,
  })
=======
resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = local.namespace
      "xkf.xenit.io/kind" = "platform"
    }
    name = local.namespace
  }
}

resource "helm_release" "cert_manager" {
  repository  = "https://charts.jetstack.io"
  chart       = "cert-manager"
  name        = "cert-manager"
  namespace   = kubernetes_namespace.this.metadata[0].name
  version     = "v1.14.4"
  max_history = 3
  skip_crds   = true
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
  })]
}

resource "helm_release" "cert_manager_extras" {
  depends_on = [helm_release.cert_manager]

  chart       = "${path.module}/charts/cert-manager-extras"
  name        = "cert-manager-extras"
  namespace   = kubernetes_namespace.this.metadata[0].name
  max_history = 3
  values = [templatefile("${path.module}/templates/cert-manager-extras-values.yaml.tpl", {
    notificationEmail    = var.notification_email,
    acmeServer           = var.acme_server,
    azureConfig          = var.azure_config,
    azureHostedZoneNames = local.azure_hosted_zone_names,
  })]
>>>>>>> 18fa30ff (Remove support for AWS cloud provider)
}
