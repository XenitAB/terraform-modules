terraform {
  required_version = "0.13.5"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

resource "helm_release" "cert_manager" {
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  name       = "cert-manager"
  namespace = "cert-manager"
  create_namespace = true
  version    = "v1.0.4"
}
