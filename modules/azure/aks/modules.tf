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
    helm = helm
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
    helm = helm
  }

  exclude = [
    {
      excluded_namespaces = ["kube-system", "gatekeeper-system", "aad-pod-identity", "cert-manager", "ingress-nginx", "velero", "azdo-proxy"]
      processes           = ["*"]
    }
  ]

  additional_constraints = [
    {
      kind       = "AzureIdentityFormat"
      name       = "azure-identity-format"
      match      = {}
      parameters = {}
    },
  ]
}

# Ingress Nginx
module "ingress_nginx" {
  for_each = {
    for s in ["ingress-nginx"] :
    s => s
    if var.ingress_nginx_enabled
  }

  source = "../../kubernetes/ingress-nginx"

  providers = {
    helm = helm
  }
}

# External DNS
module "external_dns" {
  for_each = {
    for s in ["external-dns"] :
    s => s
    if var.external_dns_enabled
  }

  source = "../../kubernetes/external-dns"

  providers = {
    helm = helm
  }

  dns_provider          = "azure"
  azure_tenant_id       = data.azurerm_client_config.current.tenant_id
  azure_subscription_id = data.azurerm_client_config.current.subscription_id
  azure_resource_group  = data.azurerm_resource_group.this.name
  azure_client_id       = var.external_dns_identity.client_id
  azure_resource_id     = var.external_dns_identity.resource_id
}

# Cert Manager
module "cert_manager" {
  for_each = {
    for s in ["cert-manager"] :
    s => s
    if var.cert_manager_enabled
  }

  source = "../../kubernetes/cert-manager"

  providers = {
    helm = helm
  }
}

# Velero
module "velero" {
  for_each = {
    for s in ["velero"] :
    s => s
    if var.velero_enabled
  }

  source = "../../kubernetes/velero"

  providers = {
    helm = helm
  }

  cloud_provider                  = "azure"
  azure_subscription_id           = data.azurerm_client_config.current.subscription_id
  azure_resource_group            = data.azurerm_resource_group.this.name
  azure_storage_account_name      = var.velero.azure_storage_account_name
  azure_storage_account_container = var.velero.azure_storage_account_container
  azure_client_id                 = var.velero.identity.client_id
  azure_resource_id               = var.velero.identity.resource_id
}
