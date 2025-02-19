/**
  * # External DNS (external-dns)
  *
  * This module is used to add [`external-dns`](https://github.com/kubernetes-sigs/external-dns) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.19.0"
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

resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "git_repository_file" "kustomization" {
  depends_on = [kubernetes_namespace.external_dns]

  path = "clusters/${var.cluster_id}/external-dns.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id,
  })
}

resource "git_repository_file" "external_dns" {
  depends_on = [kubernetes_namespace.external_dns]

  path = "platform/${var.cluster_id}/external-dns/external-dns.yaml"
  content = templatefile("${path.module}/templates/external-dns.yaml.tpl", {
    client_id           = azurerm_user_assigned_identity.external_dns.client_id,
    provider            = var.dns_provider,
    resource_group_name = var.global_resource_group_name,
    sources             = var.sources,
    extra_args          = var.extra_args,
    subscription_id     = var.subscription_id,
    tenant_id           = azurerm_user_assigned_identity.external_dns.tenant_id,
    txt_owner_id        = var.txt_owner_id,
  })
}
