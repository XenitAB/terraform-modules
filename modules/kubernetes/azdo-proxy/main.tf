# Module requirements
terraform {
  required_version = "0.13.5"

  required_providers {
    azurerm = {
      version = "2.35.0"
      source  = "hashicorp/azurerm"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

data "azurerm_key_vault_secret" "azdo_proxy_pat" {
  for_each = {
    for azure_devops_pat_keyvault in [var.azure_devops_pat_keyvault] :
    "azdo-proxy-pat" => azure_devops_pat_keyvault
    if var.azure_devops_pat_keyvault.read_azure_devops_pat_from_azure_keyvault == true
  }
  name         = each.value.key
  key_vault_id = each.value.azure_keyvault_id
}

resource "random_password" "azdo_proxy" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }

  length  = 48
  special = false

  keepers = {
    namespace = each.key
  }
}

locals {
  azdo_proxy_json = {
    domain       = var.azure_devops_domain
    pat          = var.azure_devops_pat_keyvault.read_azure_devops_pat_from_azure_keyvault ? data.azurerm_key_vault_secret.azdo_proxy_pat["azdo-proxy-pat"].value : var.azure_devops_pat
    organization = var.azure_devops_organization
    repositories = [
      for ns in var.namespaces : {
        project = ns.flux.azdo_project
        name    = ns.flux.azdo_repo
        token   = random_password.azdo_proxy[ns.name].result
      }
    ]
  }
}

resource "kubernetes_namespace" "azdo_proxy" {
  metadata {
    labels = {
      name = var.azdo_proxy_namespace
    }
    name = var.azdo_proxy_namespace
  }
}

resource "kubernetes_secret" "azdo_proxy" {
  metadata {
    name      = var.azdo_proxy_config_secret_name
    namespace = kubernetes_namespace.azdo_proxy.metadata[0].name
  }

  data = {
    "config.json" = jsonencode(local.azdo_proxy_json)
  }
}

resource "helm_release" "azdo_proxy" {
  repository = var.azdo_proxy_helm_repository
  chart      = var.azdo_proxy_helm_chart_name
  version    = var.azdo_proxy_helm_chart_version
  name       = kubernetes_namespace.azdo_proxy.metadata[0].name
  namespace  = kubernetes_namespace.azdo_proxy.metadata[0].name

  set {
    name  = "configSecretName"
    value = kubernetes_secret.azdo_proxy.metadata[0].name
  }
}
