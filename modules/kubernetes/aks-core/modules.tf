locals {
  excluded_namespaces = ["kube-system", "gatekeeper-system", "aad-pod-identity", "cert-manager", "ingress-nginx", "velero", "azdo-proxy", "flux-system", "external-dns", "csi-secrets-store-provider-azure", "falco", "reloader"]
}

# OPA Gatekeeper
module "opa_gatekeeper" {
  for_each = {
    for s in ["opa-gatekeeper"] :
    s => s
    if var.opa_gatekeeper_enabled
  }

  source = "../../kubernetes/opa-gatekeeper"

  enable_default_constraints = var.opa_gatekeeper_config.enable_default_constraints
  additional_constraints = concat(
    var.opa_gatekeeper_config.additional_constraints,
    [
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
  )
  excluded_namespaces = local.excluded_namespaces
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

  azure_devops_pat    = var.fluxcd_v1_config.azure_devops.pat
  azure_devops_org    = var.fluxcd_v1_config.azure_devops.org
  flux_status_enabled = var.fluxcd_v1_config.flux_status_enabled
  branch              = var.fluxcd_v1_config.branch
  environment         = var.environment
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
  environment       = var.environment
  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = {
      enabled     = ns.flux.enabled
      create_crds = ns.flux.create_crds
      org         = ns.flux.azure_devops.org
      proj        = ns.flux.azure_devops.proj
      repo        = ns.flux.azure_devops.repo
    }
  }]
  prometheus_enabled = var.prometheus_enabled
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
  prometheus_enabled = var.prometheus_enabled
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

  http_snippet       = var.ingress_config.http_snippet
  prometheus_enabled = var.prometheus_enabled
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
  txt_owner_id = "${var.environment}-${var.name}${var.aks_name_suffix}"
  azure_config = {
    tenant_id       = data.azurerm_client_config.current.tenant_id
    subscription_id = data.azurerm_client_config.current.subscription_id
    resource_group  = data.azurerm_resource_group.this.name
    client_id       = var.external_dns_config.client_id
    resource_id     = var.external_dns_config.resource_id
  }
  prometheus_enabled = var.prometheus_enabled
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
  cloud_provider     = "azure"
  azure_config = {
    hosted_zone_name    = var.cert_manager_config.dns_zone
    resource_group_name = data.azurerm_resource_group.this.name
    subscription_id     = data.azurerm_client_config.current.subscription_id
    client_id           = var.external_dns_config.client_id
    resource_id         = var.external_dns_config.resource_id
  }
  prometheus_enabled = var.prometheus_enabled
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
  prometheus_enabled = var.prometheus_enabled
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

  prometheus_enabled = var.prometheus_enabled
}

# datadog
module "datadog" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["datadog"] :
    s => s
    if var.datadog_enabled
  }

  source = "../../kubernetes/datadog"

  location     = var.location_short
  environment  = var.environment
  datadog_site = var.datadog_config.datadog_site
  api_key      = var.datadog_config.api_key
}

# falco
module "falco" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["falco"] :
    s => s
    if var.falco_enabled
  }

  source = "../../kubernetes/falco"

  environment     = var.environment
  datadog_site    = var.datadog_config.datadog_site
  datadog_api_key = var.datadog_config.api_key
}

# Reloader
module "reloader" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["reloader"] :
    s => s
    if var.reloader_enabled
  }

  source = "../../kubernetes/reloader"

  prometheus_enabled = var.prometheus_enabled
}

# azad-kube-proxy
module "azad_kube_proxy" {
  for_each = {
    for s in ["azad-kube-proxy"] :
    s => s
    if var.azad_kube_proxy_enabled
  }

  source = "../../kubernetes/azad-kube-proxy"

  fqdn                  = var.azad_kube_proxy_config.fqdn
  dashboard             = var.azad_kube_proxy_config.dashboard
  azure_ad_group_prefix = var.azad_kube_proxy_config.azure_ad_group_prefix
  allowed_ips           = var.azad_kube_proxy_config.allowed_ips

  azure_ad_app = {
    client_id     = var.azad_kube_proxy_config.azure_ad_app.client_id
    client_secret = var.azad_kube_proxy_config.azure_ad_app.client_secret
    tenant_id     = var.azad_kube_proxy_config.azure_ad_app.tenant_id
  }

  k8dash_config = {
    client_id     = var.azad_kube_proxy_config.k8dash_config.client_id
    client_secret = var.azad_kube_proxy_config.k8dash_config.client_secret
    scope         = var.azad_kube_proxy_config.k8dash_config.scope
  }
}

# Prometheus
module "prometheus" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["prometheus"] :
    s => s
    if var.prometheus_enabled
  }

  source = "../../kubernetes/prometheus"

  alertmanager_enabled = var.prometheus_config.alertmanager_enabled

  remote_write_enabled   = var.prometheus_config.remote_write_enabled
  remote_write_url       = var.prometheus_config.remote_write_url
  remote_tls_secret_name = var.prometheus_config.remote_tls_secret_name #tfsec:ignore:GEN003 ,it's a secret name not a secret

  volume_claim_enabled            = var.prometheus_config.volume_claim_enabled
  volume_claim_storage_class_name = var.prometheus_config.volume_claim_storage_class_name
  volume_claim_size               = var.prometheus_config.volume_claim_size
}

module "ingress_healthz" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["ingress-healthz"] :
    s => s
    if var.ingress_healthz_enabled
  }

  source = "../../kubernetes/ingress-healthz"

  environment = var.environment
  dns_zone    = var.cert_manager_config.dns_zone
}
