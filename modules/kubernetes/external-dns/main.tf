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
  values = templatefile("${path.module}/templates/values.yaml.tpl", { provider = var.dns_provider, sources = var.sources })
}

resource "helm_release" "external_dns" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  name       = "external-dns"
  namespace = "external-dns"
  create_namespace = true
  version    = "v4.0.0"
  values     = [local.values]
}
