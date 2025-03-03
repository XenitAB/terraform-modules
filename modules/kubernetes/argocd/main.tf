terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azuread = {
      version = "2.50.0"
      source  = "hashicorp/azuread"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "helm_release" "argocd" {
  depends_on = [ kubernetes_namespace.argocd ]
  
  chart       = "oci://ghcr.io/argoproj/argo-helm/argo-cd"
  name        = "argo-cd"
  namespace   = "argocd"
  version     = "7.8.7"
  max_history = 3
  values = [templatefile("${path.module}/templates/argocd-values.yaml.tpl", {
    controller_min_replicas  = var.argocd_config.controller_min_replicas
    server_min_replicas      = var.argocd_config.server_min_replicas
    repo_server_min_replicas = var.argocd_config.repo_server_min_replicas
    application_set_replicas = var.argocd_config.application_set_replicas
    ingress_whitelist_ip     = var.argocd_config.ingress_whitelist_ip
    global_domain            = var.argocd_config.global_domain
    client_id                = azuread_application.dex.client_id
    client_secret            = azuread_application_password.dex.value
    tenant                   = var.argocd_config.tenant
  })]
}