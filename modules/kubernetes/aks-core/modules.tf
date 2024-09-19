locals {
  exclude_namespaces = [
    "aad-pod-identity",
    "azad-kube-proxy",
    "azdo-proxy",
    "azure-metrics",
    "azureserviceoperator-system",
    "calico-system",
    "cert-manager",
    "controle-plane-logs",
    "datadog",
    "external-dns",
    "falco",
    "flux-system",
    "ingress-nginx",
    "ingress-healthz",
    "linkerd",
    "linkerd-cni",
    "reloader",
    "trivy",
    "tigera-operator",
    "velero",
    "grafana-agent",
    "promtail",
    "prometheus",
    "node-ttl",
    "spegel",
    "vpa",
  ]
  cluster_id = "${var.location_short}-${var.environment}-${var.name}${local.aks_name_suffix}"
  dns_zones = {
    for zone in data.azurerm_dns_zone.this :
    zone.name => zone.id
  }
}

module "aad_pod_identity" {
  for_each = {
    for s in ["aad-pod-identity"] :
    s => s
    if var.aad_pod_identity_enabled
  }

  source           = "../../kubernetes/aad-pod-identity"
  cluster_id       = local.cluster_id
  aad_pod_identity = var.aad_pod_identity_config
  namespaces = [for ns in var.namespaces : {
    name = ns.name
  }]
}

module "azad_kube_proxy" {
  for_each = {
    for s in ["azad-kube-proxy"] :
    s => s
    if var.azad_kube_proxy_enabled
  }

  source                  = "../../kubernetes/azad-kube-proxy"
  cluster_id              = local.cluster_id
  fqdn                    = var.azad_kube_proxy_config.fqdn
  azure_ad_group_prefix   = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}"
  allowed_ips             = var.azad_kube_proxy_config.allowed_ips
  private_ingress_enabled = var.ingress_nginx_config.private_ingress_enabled
  use_private_ingress     = var.use_private_ingress

  azure_ad_app = {
    client_id     = var.azad_kube_proxy_config.azure_ad_app.client_id
    client_secret = var.azad_kube_proxy_config.azure_ad_app.client_secret
    tenant_id     = var.azad_kube_proxy_config.azure_ad_app.tenant_id
  }
}

module "azure_metrics" {
  for_each = {
    for s in ["azure-metrics"] :
    s => s
    if var.azure_metrics_enabled
  }

  source = "../../kubernetes/azure-metrics"

  aks_managed_identity = data.azuread_group.aks_managed_identity.id
  aks_name             = var.name
  aks_name_suffix      = var.aks_name_suffix
  cluster_id           = local.cluster_id
  environment          = var.environment
  location             = data.azurerm_resource_group.this.location
  location_short       = var.location_short
  oidc_issuer_url      = var.oidc_issuer_url
  resource_group_name  = data.azurerm_resource_group.this.name
  subscription_id      = data.azurerm_client_config.current.subscription_id
}

module "azure_policy" {
  for_each = {
    for s in ["azure_policy"] :
    s => s
    if var.azure_policy_enabled && !var.gatekeeper_enabled
  }

  source = "../../kubernetes/azure-policy"

  aks_name            = var.name
  aks_name_suffix     = local.aks_name_suffix
  azure_policy_config = var.azure_policy_config
  environment         = var.environment
  location_short      = var.location_short
  tenant_namespaces = [
    for namespace in var.namespaces :
    namespace.name if namespace.flux.enabled
  ]
}

module "azure_service_operator" {
  for_each = {
    for s in ["azure_service_operator"] :
    s => s
    if var.azure_service_operator_enabled
  }

  source = "../../kubernetes/azure-service-operator"

  aks_name                      = var.name
  aks_name_suffix               = local.aks_name_suffix
  azure_service_operator_config = var.azure_service_operator_config
  cluster_id                    = local.cluster_id
  environment                   = var.environment
  location                      = data.azurerm_resource_group.this.location
  location_short                = var.location_short
  oidc_issuer_url               = var.oidc_issuer_url
  subscription_id               = data.azurerm_client_config.current.subscription_id
  tenant_id                     = data.azurerm_client_config.current.tenant_id
}

module "cert_manager" {
  depends_on = [module.cert_manager_crd]

  for_each = {
    for s in ["cert-manager"] :
    s => s
    if var.cert_manager_enabled
  }

  source = "../../kubernetes/cert-manager"

  cluster_id                 = local.cluster_id
  dns_zones                  = local.dns_zones
  global_resource_group_name = data.azurerm_resource_group.global.name
  location                   = data.azurerm_resource_group.this.location
  notification_email         = var.cert_manager_config.notification_email
  oidc_issuer_url            = var.oidc_issuer_url
  resource_group_name        = data.azurerm_resource_group.this.name
  subscription_id            = data.azurerm_client_config.current.subscription_id
}

module "cert_manager_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://charts.jetstack.io"
  chart_name       = "cert-manager"
  chart_version    = "v1.7.1"
  values = {
    "installCRDs" = "true"
  }
}

module "control_plane_logs" {
  for_each = {
    for s in ["control_plane_logs"] :
    s => s
    if var.control_plane_logs_enabled
  }

  source = "../../kubernetes/control-plane-logs"

  aks_name = var.name
  azure_config = {
    azure_key_vault_name = var.control_plane_logs_config.azure_key_vault_name
    eventhub_hostname    = var.control_plane_logs_config.eventhub_hostname
    eventhub_name        = var.control_plane_logs_config.eventhub_name
  }
  cluster_id          = local.cluster_id
  environment         = var.environment
  location_short      = var.location_short
  oidc_issuer_url     = var.oidc_issuer_url
  resource_group_name = data.azurerm_resource_group.this.name
}

module "datadog" {
  for_each = {
    for s in ["datadog"] :
    s => s
    if var.datadog_enabled
  }

  source = "../../kubernetes/datadog"

  apm_ignore_resources = var.datadog_config.apm_ignore_resources
  azure_config = {
    azure_key_vault_name = var.datadog_config.azure_key_vault_name
  }
  cluster_id          = local.cluster_id
  datadog_site        = var.datadog_config.datadog_site
  environment         = var.environment
  key_vault_id        = data.azurerm_key_vault.core.id
  location            = data.azurerm_resource_group.this.location
  location_short      = var.location_short
  namespace_include   = var.datadog_config.namespaces
  oidc_issuer_url     = var.oidc_issuer_url
  resource_group_name = data.azurerm_resource_group.this.name
}

module "external_dns" {
  for_each = {
    for s in ["external-dns"] :
    s => s
    if var.external_dns_enabled
  }

  source = "../../kubernetes/external-dns"

  cluster_id                 = local.cluster_id
  dns_provider               = "azure"
  dns_zones                  = local.dns_zones
  environment                = var.environment
  global_resource_group_name = data.azurerm_resource_group.global.name
  location                   = data.azurerm_resource_group.this.location
  location_short             = var.location_short
  oidc_issuer_url            = var.oidc_issuer_url
  resource_group_name        = data.azurerm_resource_group.this.name
  subscription_id            = data.azurerm_client_config.current.subscription_id
  txt_owner_id               = "${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}"
}

module "falco" {
  for_each = {
    for s in ["falco"] :
    s => s
    if var.falco_enabled
  }

  source = "../../kubernetes/falco"

  cluster_id = local.cluster_id
}

module "fluxcd_v2_azure_devops" {
  for_each = {
    for s in ["fluxcd-v2"] :
    s => s
    if var.fluxcd_v2_enabled && var.fluxcd_v2_config.type == "azure-devops"
  }

  source = "../../kubernetes/fluxcd-v2-azdo"

  environment              = var.environment
  cluster_id               = local.cluster_id
  azure_devops_pat         = var.fluxcd_v2_config.azure_devops.pat
  azure_devops_org         = var.fluxcd_v2_config.azure_devops.org
  azure_devops_proj        = var.fluxcd_v2_config.azure_devops.proj
  cluster_repo             = var.fluxcd_v2_config.azure_devops.repo
  slack_flux_alert_webhook = var.slack_flux_alert_webhook
  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = {
      enabled             = ns.flux.enabled
      create_crds         = ns.flux.create_crds
      include_tenant_name = ns.flux.include_tenant_name
      org                 = ns.flux.azure_devops.org
      proj                = ns.flux.azure_devops.proj
      repo                = ns.flux.azure_devops.repo
    }
  }]
}

module "fluxcd_v2_github" {
  for_each = {
    for s in ["fluxcd-v2"] :
    s => s
    if var.fluxcd_v2_enabled && var.fluxcd_v2_config.type == "github"
  }

  source = "../../kubernetes/fluxcd-v2-github"

  environment              = var.environment
  cluster_id               = local.cluster_id
  github_org               = var.fluxcd_v2_config.github.org
  github_app_id            = var.fluxcd_v2_config.github.app_id
  github_installation_id   = var.fluxcd_v2_config.github.installation_id
  github_private_key       = var.fluxcd_v2_config.github.private_key
  slack_flux_alert_webhook = var.slack_flux_alert_webhook
  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = {
      enabled = ns.flux.enabled
      repo    = ns.flux.github.repo
    }
  }]
}

module "gatekeeper" {
  for_each = {
    for s in ["gatekeeper"] :
    s => s
    if var.gatekeeper_enabled && !var.azure_policy_enabled
  }

  source = "../../kubernetes/gatekeeper"

  cluster_id                     = local.cluster_id
  azure_service_operator_enabled = var.azure_service_operator_enabled
  exclude_namespaces             = concat(var.gatekeeper_config.exclude_namespaces, local.exclude_namespaces)
  mirrord_enabled                = var.mirrord_enabled
  telepresence_enabled           = var.telepresence_enabled
}

module "grafana_agent" {
  depends_on = [module.grafana_agent_crd]

  for_each = {
    for s in ["grafana-agent"] :
    s => s
    if var.grafana_agent_enabled
  }

  source = "../../kubernetes/grafana-agent"

  remote_write_urls = {
    metrics = var.grafana_agent_config.remote_write_urls.metrics
    logs    = var.grafana_agent_config.remote_write_urls.logs
    traces  = var.grafana_agent_config.remote_write_urls.traces
  }

  credentials = {
    metrics_username = var.grafana_agent_config.credentials.metrics_username
    metrics_password = var.grafana_agent_config.credentials.metrics_password
    logs_username    = var.grafana_agent_config.credentials.logs_username
    logs_password    = var.grafana_agent_config.credentials.logs_password
    traces_username  = var.grafana_agent_config.credentials.traces_username
    traces_password  = var.grafana_agent_config.credentials.traces_password
  }

  cluster_id              = local.cluster_id
  cluster_name            = "${var.name}${local.aks_name_suffix}"
  environment             = var.environment
  namespace_include       = var.namespaces[*].name
  extra_namespaces        = var.grafana_agent_config.extra_namespaces
  include_kubelet_metrics = var.grafana_agent_config.include_kubelet_metrics
}

module "grafana_agent_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://grafana.github.io/helm-charts"
  chart_name       = "grafana-agent-operator"
  chart_version    = "0.1.5"
}

module "grafana_alloy" {

  for_each = {
    for s in ["grafana-alloy"] :
    s => s
    if var.grafana_alloy_enabled
  }

  source = "../../kubernetes/grafana-alloy"

  azure_config = {
    azure_key_vault_name = var.grafana_alloy_config.azure_key_vault_name
    keyvault_secret_name = var.grafana_alloy_config.keyvault_secret_name
  }
  grafana_alloy_config = {
    grafana_otelcol_auth_basic_username = var.grafana_alloy_config.grafana_otelcol_auth_basic_username
    grafana_otelcol_exporter_endpoint   = var.grafana_alloy_config.grafana_otelcol_exporter_endpoint
  }
  aks_name            = var.name
  cluster_id          = local.cluster_id
  environment         = var.environment
  location_short      = data.azurerm_resource_group.this.location
  oidc_issuer_url     = var.oidc_issuer_url
  resource_group_name = data.azurerm_resource_group.this.name
}
module "grafana_k8s_monitoring" {

  for_each = {
    for s in ["grafana_k8s_monitoring"] :
    s => s
    if var.grafana_k8s_monitoring_enabled
  }

  source = "../../kubernetes/grafana-k8s-monitoring"

  key_vault_id        = data.azurerm_key_vault.core.id
  location            = data.azurerm_resource_group.this.location
  oidc_issuer_url     = var.oidc_issuer_url
  resource_group_name = data.azurerm_resource_group.this.name
  cluster_id          = local.cluster_id
  cluster_name        = var.grafana_k8s_monitor_config.cluster_name
  grafana_k8s_monitor_config = {
    azure_key_vault_name          = var.grafana_k8s_monitor_config.azure_key_vault_name
    grafana_cloud_prometheus_host = var.grafana_k8s_monitor_config.grafana_cloud_prometheus_host
    grafana_cloud_loki_host       = var.grafana_k8s_monitor_config.grafana_cloud_loki_host
    grafana_cloud_tempo_host      = var.grafana_k8s_monitor_config.grafana_cloud_tempo_host
    include_namespaces            = var.grafana_k8s_monitor_config.include_namespaces
    include_namespaces_piped      = var.grafana_k8s_monitor_config.include_namespaces_piped
    exclude_namespaces            = var.grafana_k8s_monitor_config.exclude_namespaces
  }
}
module "ingress_healthz" {
  depends_on = [module.linkerd]

  for_each = {
    for s in ["ingress-healthz"] :
    s => s
    if var.ingress_healthz_enabled
  }
  source = "../../kubernetes/ingress-healthz"

  environment     = var.environment
  dns_zone        = var.cert_manager_config.dns_zone[0]
  location_short  = var.location_short
  linkerd_enabled = var.linkerd_enabled
  cluster_id      = local.cluster_id
}

module "ingress_nginx" {
  depends_on = [module.linkerd]

  for_each = {
    for s in ["ingress-nginx"] :
    s => s
    if var.ingress_nginx_enabled
  }

  source = "../../kubernetes/ingress-nginx"

  external_dns_hostname = var.external_dns_hostname
  default_certificate = {
    enabled  = true
    dns_zone = var.cert_manager_config.dns_zone[0]
  }
  private_ingress_enabled = var.ingress_nginx_config.private_ingress_enabled
  customization           = var.ingress_nginx_config.customization
  customization_private   = var.ingress_nginx_config.customization_private
  linkerd_enabled         = var.linkerd_enabled
  datadog_enabled         = var.datadog_enabled
  cluster_id              = local.cluster_id
}

module "linkerd" {
  depends_on = [module.cert_manager_crd, module.linkerd_crd]

  for_each = {
    for s in ["linkerd"] :
    s => s
    if var.linkerd_enabled
  }

  source = "../../kubernetes/linkerd"
}

module "linkerd_crd" {
  source = "../../kubernetes/helm-crd-oci"

  for_each = {
    for s in ["linkerd"] :
    s => s
    if var.linkerd_enabled
  }

  chart         = "oci://ghcr.io/xenitab/helm-charts/linkerd-crds"
  chart_name    = "linkerd-crd"
  chart_version = "2.12.2"
}

module "node_local_dns" {
  for_each = {
    for s in ["node-local-dns"] :
    s => s
    if var.node_local_dns_enabled
  }

  source = "../../kubernetes/node-local-dns"

  cluster_id       = local.cluster_id
  dns_ip           = "10.0.0.10"
  coredns_upstream = var.coredns_upstream
}

module "node_ttl" {
  for_each = {
    for s in ["node-ttl"] :
    s => s
    if var.node_ttl_enabled
  }

  source = "../../kubernetes/node-ttl"

  cluster_id                  = local.cluster_id
  status_config_map_namespace = "kube-system"
}

module "prometheus" {
  depends_on = [module.prometheus_crd]

  for_each = {
    for s in ["prometheus"] :
    s => s
    if var.prometheus_enabled
  }

  source = "../../kubernetes/prometheus"

  aks_name = var.name
  azure_config = {
    azure_key_vault_name = var.prometheus_config.azure_key_vault_name
  }

  cluster_id                      = local.cluster_id
  cluster_name                    = "${var.name}${local.aks_name_suffix}"
  environment                     = var.environment
  location_short                  = var.location_short
  namespace_selector              = var.prometheus_config.namespace_selector
  oidc_issuer_url                 = var.oidc_issuer_url
  region                          = var.location_short
  remote_write_authenticated      = var.prometheus_config.remote_write_authenticated
  remote_write_url                = var.prometheus_config.remote_write_url
  resource_group_name             = data.azurerm_resource_group.this.name
  resource_selector               = var.prometheus_config.resource_selector
  volume_claim_storage_class_name = var.prometheus_volume_claim_storage_class_name
  volume_claim_size               = var.prometheus_config.volume_claim_size

  aad_pod_identity_enabled = var.aad_pod_identity_enabled
  azad_kube_proxy_enabled  = var.azad_kube_proxy_enabled
  falco_enabled            = var.falco_enabled
  flux_enabled             = var.fluxcd_v2_enabled
  gatekeeper_enabled       = var.gatekeeper_enabled
  grafana_agent_enabled    = var.grafana_agent_enabled
  linkerd_enabled          = var.linkerd_enabled
  node_local_dns_enabled   = var.node_local_dns_enabled
  node_ttl_enabled         = var.node_ttl_enabled
  promtail_enabled         = var.promtail_enabled
  spegel_enabled           = var.spegel_enabled
  trivy_enabled            = var.trivy_enabled
  vpa_enabled              = var.vpa_enabled
}

module "prometheus_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://prometheus-community.github.io/helm-charts"
  chart_name       = "kube-prometheus-stack"
  chart_version    = "42.1.1"
}

module "promtail" {
  for_each = {
    for s in ["promtail"] :
    s => s
    if var.promtail_enabled
  }

  source = "../../kubernetes/promtail"

  aks_name = var.name
  azure_config = {
    azure_key_vault_name = var.promtail_config.azure_key_vault_name
  }
  cluster_id          = local.cluster_id
  cluster_name        = "${var.name}${local.aks_name_suffix}"
  environment         = var.environment
  excluded_namespaces = var.promtail_config.excluded_namespaces
  location_short      = var.location_short
  loki_address        = var.promtail_config.loki_address
  oidc_issuer_url     = var.oidc_issuer_url
  region              = var.location_short
  resource_group_name = data.azurerm_resource_group.this.name
}

module "reloader" {
  for_each = {
    for s in ["reloader"] :
    s => s
    if var.reloader_enabled
  }

  source     = "../../kubernetes/reloader"
  cluster_id = local.cluster_id
}

module "trivy" {
  depends_on = [module.trivy_crd]

  for_each = {
    for s in ["trivy"] :
    s => s
    if var.trivy_enabled && !var.defender_enabled
  }

  source = "../../kubernetes/trivy"

  acr_name_override               = var.acr_name_override
  aks_managed_identity            = data.azuread_group.aks_managed_identity.id
  aks_name                        = var.name
  cluster_id                      = local.cluster_id
  environment                     = var.environment
  location                        = data.azurerm_resource_group.this.location
  location_short                  = var.location_short
  oidc_issuer_url                 = var.oidc_issuer_url
  resource_group_name             = data.azurerm_resource_group.this.name
  starboard_exporter_enabled      = var.trivy_config.starboard_exporter_enabled
  unique_suffix                   = var.unique_suffix
  volume_claim_storage_class_name = var.trivy_volume_claim_storage_class_name
}

module "trivy_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://aquasecurity.github.io/helm-charts/"
  chart_name       = "trivy-operator"
  chart_version    = "0.11.0"
}

module "velero" {
  for_each = {
    for s in ["velero"] :
    s => s
    if var.velero_enabled
  }

  source = "../../kubernetes/velero"

  aks_managed_identity = data.azuread_group.aks_managed_identity.id
  azure_config = {
    storage_account_name      = var.velero_config.azure_storage_account_name
    storage_account_container = var.velero_config.azure_storage_account_container
  }
  cluster_id          = local.cluster_id
  location            = data.azurerm_resource_group.this.location
  oidc_issuer_url     = var.oidc_issuer_url
  resource_group_name = data.azurerm_resource_group.this.name
  subscription_id     = data.azurerm_client_config.current.subscription_id
  unique_suffix       = var.unique_suffix
  environment         = var.environment
}

module "vpa" {
  for_each = {
    for s in ["vpa"] :
    s => s
    if var.vpa_enabled
  }

  source = "../../kubernetes/vpa"

  cluster_id = local.cluster_id
}

module "spegel" {
  for_each = {
    for s in ["spegel"] :
    s => s
    if var.spegel_enabled
  }

  source = "../../kubernetes/spegel"

  cluster_id       = local.cluster_id
  private_registry = "https://${data.azurerm_container_registry.acr.login_server}"
}

module "telepresence" {
  for_each = {
    for s in ["telepresence"] :
    s => s
    if var.telepresence_enabled
  }

  source = "../../kubernetes/telepresence"

  cluster_id          = local.cluster_id
  telepresence_config = var.telepresence_config
}
