terraform {
  required_version = "0.13.5"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

resource "helm_release" "external_dns" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  name       = "external-dns"
  namespace = "external-dns"
  version    = "v4.0.0"
}
