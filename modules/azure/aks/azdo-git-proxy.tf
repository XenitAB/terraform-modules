data "azurerm_key_vault_secret" "azdo_git_proxy_pat" {
  name         = "azure-devops-pat"
  key_vault_id = data.azurerm_key_vault.coreKv.id
}

resource "random_password" "azdo_git_proxy" {
  for_each = {
    for ns in local.k8sNamespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  length  = 48
  special = false

  keepers = {
    namespace = each.key
  }
}

locals {
  azdo_git_proxy_json = {
    domain       = var.azdo_git_proxy.azdo_domain
    pat          = data.azurerm_key_vault_secret.azdo_git_proxy_pat.value
    organization = var.azdo_git_proxy.azdo_organization
    repositories = [
      for ns in local.k8sNamespaces : {
        project = ns.flux.azdo_project
        name    = ns.flux.azdo_repo
        token   = random_password.azdo_git_proxy[ns.name].result
      }
    ]
  }
}

resource "kubernetes_namespace" "azdo_git_proxy" {
  metadata {
    labels = {
      name = "azdo-git-proxy"
    }
    name = "azdo-git-proxy"
  }
}

resource "kubernetes_secret" "azdo_git_proxy" {
  metadata {
    name      = "azdo-git-proxy-config"
    namespace = kubernetes_namespace.azdo_git_proxy.metadata[0].name
  }

  data = {
    "config.json" = jsonencode(local.azdo_git_proxy_json)
  }
}

resource "helm_release" "azdo_git_proxy" {
  name       = var.azdo_git_proxy.chart
  repository = var.azdo_git_proxy.repository
  chart      = var.azdo_git_proxy.chart
  version    = var.azdo_git_proxy.version
  namespace  = kubernetes_namespace.azdo_git_proxy.metadata[0].name

  set {
    name  = "configSecretName"
    value = kubernetes_secret.azdo_git_proxy.metadata[0].name
  }
}
