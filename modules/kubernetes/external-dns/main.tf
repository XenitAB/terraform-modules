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
  values = templatefile("${path.module}/templates/values.yaml.tpl", { provider = var.dns_provider, sources = var.sources, azure_tenant_id = var.azure_tenant_id, azure_subscription_id = var.azure_subscription_id, azure_resource_group = var.azure_resource_group })
}

resource "helm_release" "external_dns" {
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  name             = "external-dns"
  namespace        = "external-dns"
  create_namespace = true
  version          = "v4.0.0"
  values           = [local.values]
}

resource "helm_release" "aad_pod_identity" {
  depends_on = [helm_release.external_dns]

  chart            = "${path.module}/charts/aad-pod-identity"
  name             = "aad-pod-identity"
  namespace        = "external-dns"

  set {
    name  = "resourceID"
    value = var.azure_resource_group
  }

  set {
    name  = "clientID"
    value = var.azure_client_id
  }
}
