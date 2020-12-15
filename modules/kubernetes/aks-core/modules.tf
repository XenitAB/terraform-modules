locals {
  excluded_namespaces = ["kube-system", "gatekeeper-system", "aad-pod-identity", "cert-manager", "ingress-nginx", "velero", "azdo-proxy", "flux-system", "external-dns", "kyverno", "csi-secrets-store-provider-azure"]
}

# OPA Gatekeeper
module "opa_gatekeeper" {
  for_each = {
    for s in ["opa-gatekeeper"] :
    s => s
    if var.opa_gatekeeper_enabled
  }

  source = "../../kubernetes/opa-gatekeeper"

  exclude = [
    {
      excluded_namespaces = local.excluded_namespaces
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

# FluxCD v1
module "fluxcd_v1_azure_devops" {
  depends_on = [kubernetes_namespace.tenant, module.opa_gatekeeper]

  for_each = {
    for s in ["fluxcd-v1"] :
    s => s
    if var.fluxcd_v1_enabled
  }

  source = "../../kubernetes/fluxcd-v1"

  azure_devops_pat = var.fluxcd_v1_config.azure_devops.pat
  azure_devops_org = var.fluxcd_v1_config.azure_devops.org
  environment      = var.environment
  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = ns.flux
  }]
}

# FluxCD v2
module "fluxcd_v2_azure_devops" {
  for_each = {
    for s in ["fluxcd-v2"] :
    s => s
    if var.fluxcd_v2_enabled && var.fluxcd_v2_config.type == "azure-devops"
  }

  source = "../../kubernetes/fluxcd-v2-azdo"

  azure_devops_pat  = var.fluxcd_v2_config.azure_devops.pat
  azure_devops_org  = var.fluxcd_v2_config.azure_devops.org
  azure_devops_proj = var.fluxcd_v2_config.azure_devops.proj
  bootstrap_path    = var.environment
  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = ns.flux
  }]
}

module "fluxcd_v2_github" {
  for_each = {
    for s in ["fluxcd-v2"] :
    s => s
    if var.fluxcd_v2_enabled && var.fluxcd_v2_config.type == "github"
  }

  source = "../../kubernetes/fluxcd-v2-github"

  github_owner = var.fluxcd_v2_config.github.owner
  environment  = var.environment
  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = {
      enabled = ns.flux.enabled
      repo    = ns.flux.github.repo
    }
  }]
}

# AAD-Pod-Identity
module "aad_pod_identity" {
  depends_on = [kubernetes_namespace.tenant, module.opa_gatekeeper]

  for_each = {
    for s in ["aad-pod-identity"] :
    s => s
    if var.aad_pod_identity_enabled
  }

  source = "../../kubernetes/aad-pod-identity"

  aad_pod_identity = var.aad_pod_identity_config
  namespaces = [for ns in var.namespaces : {
    name = ns.name
  }]
}

# Ingress Nginx
module "ingress_nginx" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["ingress-nginx"] :
    s => s
    if var.ingress_nginx_enabled
  }

  source = "../../kubernetes/ingress-nginx"
}

# External DNS
module "external_dns" {
  depends_on = [module.opa_gatekeeper, module.aad_pod_identity]

  for_each = {
    for s in ["external-dns"] :
    s => s
    if var.external_dns_enabled
  }

  source = "../../kubernetes/external-dns"

  dns_provider = "azure"
  azure_config = {
    tenant_id       = data.azurerm_client_config.current.tenant_id
    subscription_id = data.azurerm_client_config.current.subscription_id
    resource_group  = data.azurerm_resource_group.this.name
    client_id       = var.external_dns_config.client_id
    resource_id     = var.external_dns_config.resource_id
  }
}

# Cert Manager
module "cert_manager" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["cert-manager"] :
    s => s
    if var.cert_manager_enabled
  }

  source = "../../kubernetes/cert-manager"

  notification_email = var.cert_manager_config.notification_email
  cloud_provider = "azure"
  azure_config = {
    hosted_zone_name = var.cert_manager_config.hosted_zone_name
    resource_group_name  = data.azurerm_resource_group.this.name
    subscription_id = data.azurerm_client_config.current.subscription_id
    client_id       = var.external_dns_config.client_id
    resource_id     = var.external_dns_config.resource_id
  }
}

# Velero
module "velero" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["velero"] :
    s => s
    if var.velero_enabled
  }

  source = "../../kubernetes/velero"

  cloud_provider = "azure"
  azure_config = {
    subscription_id           = data.azurerm_client_config.current.subscription_id
    resource_group            = data.azurerm_resource_group.this.name
    storage_account_name      = var.velero_config.azure_storage_account_name
    storage_account_container = var.velero_config.azure_storage_account_container
    client_id                 = var.velero_config.identity.client_id
    resource_id               = var.velero_config.identity.resource_id
  }
}

# Kyverno
module "kyverno" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["kyverno"] :
    s => s
    if var.kyverno_enabled
  }

  source = "../../kubernetes/kyverno"

  excluded_namespaces = local.excluded_namespaces
}

# csi-secrets-store-provider-azure
module "csi_secrets_store_provider_azure" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["csi-secrets-store-provider-azure"] :
    s => s
    if var.csi_secrets_store_provider_azure_enabled
  }

  source = "../../kubernetes/csi-secrets-store-provider-azure"
}
