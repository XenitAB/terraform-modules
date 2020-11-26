# FluxCD v2
module "fluxcd_v2" {
  for_each = {
    for s in ["fluxcd-v2"] :
    s => s
    if var.fluxcd_v2_enabled
  }

  source = "../../kubernetes/fluxcd-v2"

  providers = {
    helm        = helm
    azuredevops = azuredevops
  }

  azdo_org  = var.azure_devops_organization
  azdo_proj = var.azure_devops_project
  azdo_pat  = data.azurerm_key_vault_secret.azdo_pat.value
  git_path  = var.environment

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
      excluded_namespaces = ["kube-system", "gatekeeper-system", "aad-pod-identity", "cert-manager", "ingress-nginx", "velero", "azdo-proxy", "flux-system"]
      processes           = ["*"]
    }
  ]

  additional_constraints = [
    {
      kind               = "AzureIdentityFormat"
      name               = "azure-identity-format"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
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

  dns_provider = "azure"
  azure_config = {
    tenant_id       = data.azurerm_client_config.current.tenant_id
    subscription_id = data.azurerm_client_config.current.subscription_id
    resource_group  = data.azurerm_resource_group.this.name
    client_id       = var.external_dns_identity.client_id
    resource_id     = var.external_dns_identity.resource_id
  }
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
