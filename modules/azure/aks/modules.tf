# Azure DevOps Proxy
module "azdo_proxy" {
  for_each = {
    for s in ["azdo-proxy"] :
    s => s
    if var.azdo_proxy_enabled
  }

  source = "../../kubernetes/azdo-proxy"

  providers = {
    azurerm    = azurem
    kubernetes = kubernetes
    helm       = helm
  }

  azure_devops_organization = var.azure_devops_organization

  azure_devops_pat_keyvault = {
    read_azure_devops_pat_from_azure_keyvault = true
    azure_keyvault_id                         = data.azurerm_key_vault.core.id
    key                                       = "azure-devops-pat"
  }

  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = ns.flux
  }]
}

# FluxCD v1
module "fluxcd_v1" {
  depends_on = [kubernetes_namespace.group]

  for_each = {
    for s in ["fluxcd-v1"] :
    s => s
    if var.fluxcd_v1_enabled
  }

  source = "../../kubernetes/fluxcd-v1"

  providers = {
    helm = helm
  }

  azdo_proxy_enabled         = var.azdo_proxy_enabled
  azdo_proxy_local_passwords = module.azdo_proxy["azdo-proxy"].azdo_proxy_local_passwords
  fluxcd_v1_git_path         = var.environment

  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = ns.flux
  }]
}

# Helm Operator
module "helm_operator" {
  depends_on = [kubernetes_namespace.group]

  for_each = {
    for s in ["helm-operator"] :
    s => s
    if var.helm_operator_enabled
  }

  source = "../../kubernetes/helm-operator"

  providers = {
    helm = helm
  }

  helm_operator_credentials  = var.helm_operator_credentials
  acr_name                   = var.acr_name
  azdo_proxy_enabled         = var.azdo_proxy_enabled
  azdo_proxy_local_passwords = module.azdo_proxy["azdo-proxy"].azdo_proxy_local_passwords

  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = ns.flux
  }]
}


# AAD-Pod-Identity
module "aad_pod_identity" {
  depends_on = [kubernetes_namespace.group]

  for_each = {
    for s in ["aad-pod-identity"] :
    s => s
    if var.aad_pod_identity_enabled
  }

  source = "../../kubernetes/aad-pod-identity"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  aad_pod_identity = var.aad_pod_identity
  namespaces = [for ns in var.namespaces : {
    name = ns.name
  }]
}

# OPA Gatekeeper
module "opa_gatekeeper" {
  for_each = {
    for s in ["opa-gatekeeper"] :
    s => s
    if var.opa_gatekeeper_enabled
  }

  source = "../../kubernetes/opa-gatekeeper"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
