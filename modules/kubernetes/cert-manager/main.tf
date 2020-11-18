terraform {
  required_version = "0.13.5"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

locals {
  values = templatefile("${path.module}/templates/values.yaml.tpl", {})
}

resource "helm_release" "cert_manager" {
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "v1.0.4"
  values           = [local.values]
}

resource "helm_release" "cert_manager_extras" {
  depends_on = [helm_release.cert_manager]

  chart     = "${path.module}/charts/cert-manager-extras"
  name      = "cert-manager-extras"
  namespace = "cert-manager"

  set {
    name  = "notificationEmail"
    value = var.notification_email
  }
}
