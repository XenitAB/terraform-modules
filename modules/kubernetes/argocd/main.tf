terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azuread = {
      version = "2.50.0"
      source  = "hashicorp/azuread"
    }
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

locals {
  key_vault_secret_names = flatten([
    for azure_tenant in var.argocd_config.azure_tenants : [
      for cluster in azure_tenant.clusters : [
        for tenant in cluster.tenants : [
          tenant.secret_name
        ]
      ]
    ]
  ])

  key_vault_secret_values = [
    for s in local.key_vault_secret_names :
    {
      name : s
      value : data.azurerm_key_vault_secret.pat[s].value
    }
  ]
}

data "azurerm_key_vault" "core" {
  resource_group_name = var.core_resource_group_name
  name                = var.key_vault_name
}

data "azurerm_key_vault_secret" "pat" {
  for_each = tomap({
    for secret in distinct(local.key_vault_secret_names) : secret => secret
  })
  name         = each.key
  key_vault_id = data.azurerm_key_vault.core.id
}


resource "kubernetes_namespace" "argocd" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if length(var.argocd_config.azure_tenants) > 0
  }

  metadata {
    name = "argocd"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "helm_release" "argocd" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if length(var.argocd_config.azure_tenants) > 0
  }

  depends_on  = [kubernetes_namespace.argocd]
  chart       = "oci://ghcr.io/argoproj/argo-helm/argo-cd"
  name        = "argo-cd"
  namespace   = "argocd"
  version     = "7.8.8"
  max_history = 3

  values = [templatefile("${path.module}/templates/argocd-values.yaml.tpl", {
    client_id                = azurerm_user_assigned_identity.argocd.client_id
    tenant_id                = azurerm_user_assigned_identity.argocd.tenant_id
    controller_min_replicas  = var.argocd_config.controller_min_replicas
    server_min_replicas      = var.argocd_config.server_min_replicas
    repo_server_min_replicas = var.argocd_config.repo_server_min_replicas
    application_set_replicas = var.argocd_config.application_set_replicas
    ingress_whitelist_ip     = var.argocd_config.ingress_whitelist_ip
    global_domain            = var.argocd_config.global_domain
    dex_tenant_name          = var.argocd_config.dex_tenant_name
    dex_client_id            = azuread_application.dex["argocd"].client_id
    dex_client_secret        = azuread_application_password.dex["argocd"].value
    aad_group_name           = var.argocd_config.aad_group_name
    azure_tenants            = var.argocd_config.azure_tenants
  })]
}