module "aad_pod_identity" {
  for_each = {
    for s in ["aad-pod-identity"] :
    s => s
    if var.platform_config.aad_pod_identity_enabled
  }

  source           = "../../kubernetes/aad-pod-identity"
  cluster_id       = local.cluster_id
  aad_pod_identity = var.aad_pod_identity_config
  namespaces = [for ns in var.namespaces : {
    name = ns.name
  }]
  environment        = var.environment
  tenant_name        = var.platform_config.tenant_name
  fleet_infra_config = var.platform_config.fleet_infra_config
}

module "argocd" {
  depends_on = [module.karpenter]

  for_each = {
    for s in ["argocd"] :
    s => s
    if var.platform_config.argocd_enabled
  }

  source = "../../kubernetes/argocd"

  aks_cluster_id           = data.azurerm_kubernetes_cluster.this.id
  argocd_config            = var.argocd_config
  cluster_id               = local.cluster_id
  environment              = var.environment
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  core_resource_group_name = "rg-${var.environment}-${var.location_short}-${var.core_name}"
  key_vault_name           = data.azurerm_key_vault.core.name
  fleet_infra_config       = var.platform_config.fleet_infra_config
  tenant_name              = var.platform_config.tenant_name
}

module "azure_metrics" {
  for_each = {
    for s in ["azure-metrics"] :
    s => s
    if var.platform_config.azure_metrics_enabled
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
  tenant_name          = var.platform_config.tenant_name
  fleet_infra_config   = var.platform_config.fleet_infra_config
}

module "azure_policy" {
  for_each = {
    for s in ["azure_policy"] :
    s => s
    if var.platform_config.azure_policy_enabled && !var.platform_config.gatekeeper_enabled
  }

  source = "../../kubernetes/azure-policy"

  aks_name            = var.name
  aks_name_suffix     = local.aks_name_suffix
  azure_policy_config = var.azure_policy_config
  environment         = var.environment
  location_short      = var.location_short
  tenant_namespaces = [
    for namespace in var.namespaces : namespace.name
  ]
}

module "azure_service_operator" {
  for_each = {
    for s in ["azure_service_operator"] :
    s => s
    if var.platform_config.azure_service_operator_enabled
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
  tenant_name                   = var.platform_config.tenant_name
  fleet_infra_config            = var.platform_config.fleet_infra_config
}

module "cert_manager" {
  for_each = {
    for s in ["cert-manager"] :
    s => s
    if var.platform_config.cert_manager_enabled
  }

  source = "../../kubernetes/cert-manager"

  aad_groups                 = local.aad_groups_view
  cluster_id                 = local.cluster_id
  dns_zones                  = local.dns_zones
  global_resource_group_name = data.azurerm_resource_group.global.name
  location                   = data.azurerm_resource_group.this.location
  namespaces                 = var.namespaces
  notification_email         = var.cert_manager_config.notification_email
  oidc_issuer_url            = var.oidc_issuer_url
  resource_group_name        = data.azurerm_resource_group.this.name
  subscription_id            = data.azurerm_client_config.current.subscription_id
  gateway_api_enabled        = var.platform_config.gateway_api_enabled
  gateway_api_config         = var.gateway_api_config
  tenant_name                = var.platform_config.tenant_name
  environment                = var.environment
  fleet_infra_config         = var.platform_config.fleet_infra_config
  rbac_create                = var.cert_manager_config.rbac_create
}

module "envoy_gateway" {
  for_each = {
    for s in ["envoy-gateway"] :
    s => s
    if var.platform_config.envoy_gateway_enabled
  }

  source = "../../kubernetes/envoy-gateway"

  cluster_id           = local.cluster_id
  environment          = var.environment
  envoy_gateway_config = var.envoy_gateway_config
  tenant_name          = var.platform_config.tenant_name
  fleet_infra_config   = var.platform_config.fleet_infra_config
  healthz_config = {
    hostname      = var.platform_config.ingress_nginx_enabled ? var.cert_manager_config.dns_zone[0] : var.cert_manager_config.dns_zone[0]
    whitelist_ips = var.envoy_gateway_config.healthz_whitelist_ips
  }
}

module "control_plane_logs" {
  for_each = {
    for s in ["control_plane_logs"] :
    s => s
    if var.platform_config.control_plane_logs_enabled
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
  tenant_name         = var.platform_config.tenant_name
  fleet_infra_config  = var.platform_config.fleet_infra_config
}

module "datadog" {
  for_each = {
    for s in ["datadog"] :
    s => s
    if var.platform_config.datadog_enabled
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
  tenant_name         = var.platform_config.tenant_name
  fleet_infra_config  = var.platform_config.fleet_infra_config
}

module "eck_operator" {

  for_each = {
    for s in ["eck_operator"] :
    s => s
    if var.platform_config.eck_operator_enabled
  }

  source                 = "../../kubernetes/eck-operator"
  cluster_id             = local.cluster_id
  eck_managed_namespaces = var.eck_operator_config.eck_managed_namespaces
  tenant_name            = var.platform_config.tenant_name
  environment            = var.environment
  fleet_infra_config     = var.platform_config.fleet_infra_config
}

module "external_dns" {
  depends_on = [module.gateway_api]

  for_each = {
    for s in ["external-dns"] :
    s => s
    if var.platform_config.external_dns_enabled
  }

  source = "../../kubernetes/external-dns"

  aad_groups                 = local.aad_groups_view
  cluster_id                 = local.cluster_id
  dns_provider               = "azure"
  dns_zones                  = local.dns_zones
  environment                = var.environment
  global_resource_group_name = data.azurerm_resource_group.global.name
  location                   = data.azurerm_resource_group.this.location
  location_short             = var.location_short
  namespaces                 = var.namespaces
  oidc_issuer_url            = var.oidc_issuer_url
  resource_group_name        = data.azurerm_resource_group.this.name
  subscription_id            = data.azurerm_client_config.current.subscription_id
  txt_owner_id               = "${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}"
  sources                    = var.external_dns_config.sources
  extra_args                 = var.external_dns_config.extra_args
  tenant_name                = var.platform_config.tenant_name
  fleet_infra_config         = var.platform_config.fleet_infra_config
  rbac_create                = var.external_dns_config.rbac_create
}

module "external_secrets_operator" {
  for_each = {
    for s in ["external-secrets"] :
    s => s
    if var.platform_config.external_secrets_operator_enabled
  }

  source = "../../kubernetes/external-secrets-operator"

  cluster_id              = local.cluster_id
  environment             = var.environment
  external_secrets_config = var.external_secrets_config
  tenant_name             = var.platform_config.tenant_name
  fleet_infra_config      = var.platform_config.fleet_infra_config
}

module "falco" {
  for_each = {
    for s in ["falco"] :
    s => s
    if var.platform_config.falco_enabled
  }

  source = "../../kubernetes/falco"

  cluster_id         = local.cluster_id
  cilium_enabled     = var.platform_config.cilium_enabled
  tenant_name        = var.platform_config.tenant_name
  environment        = var.environment
  fleet_infra_config = var.platform_config.fleet_infra_config
}

module "fluxcd" {
  depends_on = [module.karpenter]

  for_each = {
    for s in ["fluxcd"] :
    s => s
    if var.platform_config.fluxcd_enabled
  }

  source = "../../kubernetes/fluxcd"

  environment          = var.environment
  cluster_id           = "${var.location_short}-${var.environment}-${var.name}${local.aks_name_suffix}"
  git_provider         = var.fluxcd_config.git_provider
  tenant_name          = var.platform_config.tenant_name
  fleet_infra_config   = var.platform_config.fleet_infra_config
  location_short       = var.location_short
  oidc_issuer_url      = var.oidc_issuer_url
  resource_group_name  = data.azurerm_resource_group.this.name
  acr_name_override    = var.acr_name_override
  aks_managed_identity = data.azuread_group.aks_managed_identity.id
  aks_name             = var.name
  location             = data.azurerm_resource_group.this.location
  unique_suffix        = var.unique_suffix
  namespaces = [for ns in var.namespaces : {
    name   = ns.name
    labels = ns.labels
    fluxcd = ns.flux
  }]
}

module "gatekeeper" {
  for_each = {
    for s in ["gatekeeper"] :
    s => s
    if var.platform_config.gatekeeper_enabled && !var.platform_config.azure_policy_enabled
  }

  source = "../../kubernetes/gatekeeper"

  cluster_id                     = local.cluster_id
  azure_service_operator_enabled = var.platform_config.azure_service_operator_enabled
  exclude_namespaces             = concat(var.gatekeeper_config.exclude_namespaces, local.exclude_namespaces)
  mirrord_enabled                = var.platform_config.mirrord_enabled
  tenant_name                    = var.platform_config.tenant_name
  environment                    = var.environment
  fleet_infra_config             = var.platform_config.fleet_infra_config
}

module "gateway_api" {
  for_each = {
    for s in ["gateway-api"] :
    s => s
    if var.platform_config.gateway_api_enabled
  }

  source = "../../kubernetes/gateway-api"

  cluster_id         = local.cluster_id
  gateway_api_config = var.gateway_api_config
  tenant_name        = var.platform_config.tenant_name
  environment        = var.environment
  fleet_infra_config = var.platform_config.fleet_infra_config
}

module "grafana_alloy" {

  for_each = {
    for s in ["grafana-alloy"] :
    s => s
    if var.platform_config.grafana_alloy_enabled
  }

  source = "../../kubernetes/grafana-alloy"

  azure_config = {
    azure_key_vault_name = var.grafana_alloy_config.azure_key_vault_name
    keyvault_secret_name = var.grafana_alloy_config.keyvault_secret_name
  }
  remote_write_urls = {
    metrics = var.grafana_alloy_config.remote_write_urls.metrics
    logs    = var.grafana_alloy_config.remote_write_urls.logs
    traces  = var.grafana_alloy_config.remote_write_urls.traces
  }
  aks_name                = var.name
  cluster_id              = local.cluster_id
  cluster_name            = "${var.name}${local.aks_name_suffix}"
  environment             = var.environment
  location_short          = var.location_short
  namespace_include       = length(var.namespaces) > 0 ? var.namespaces[*].name : []
  extra_namespaces        = var.grafana_alloy_config.extra_namespaces
  include_kubelet_metrics = var.grafana_alloy_config.include_kubelet_metrics
  oidc_issuer_url         = var.oidc_issuer_url
  resource_group_name     = data.azurerm_resource_group.this.name
  tenant_name             = var.platform_config.tenant_name
  fleet_infra_config      = var.platform_config.fleet_infra_config
}

module "grafana_k8s_monitoring" {

  for_each = {
    for s in ["grafana_k8s_monitoring"] :
    s => s
    if var.platform_config.grafana_k8s_monitoring_enabled
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
    exclude_namespaces            = var.grafana_k8s_monitor_config.exclude_namespaces
    node_exporter_node_affinity   = var.grafana_k8s_monitor_config.node_exporter_node_affinity
  }
  aad_pod_identity_enabled = var.platform_config.aad_pod_identity_enabled
  cilium_enabled           = var.platform_config.cilium_enabled
  falco_enabled            = var.platform_config.falco_enabled
  gatekeeper_enabled       = var.platform_config.gatekeeper_enabled
  grafana_alloy_enabled    = var.platform_config.grafana_alloy_enabled
  linkerd_enabled          = var.platform_config.linkerd_enabled
  node_local_dns_enabled   = var.platform_config.node_local_dns_enabled
  node_ttl_enabled         = var.platform_config.node_ttl_enabled
  promtail_enabled         = var.platform_config.promtail_enabled
  spegel_enabled           = var.platform_config.spegel_enabled
  trivy_enabled            = var.platform_config.trivy_enabled
  tenant_name              = var.platform_config.tenant_name
  environment              = var.environment
  fleet_infra_config       = var.platform_config.fleet_infra_config
  subscription_id          = data.azurerm_client_config.current.subscription_id
}

module "ingress_nginx" {
  depends_on = [module.linkerd]

  for_each = {
    for s in ["ingress-nginx"] :
    s => s
    if var.platform_config.ingress_nginx_enabled
  }

  source = "../../kubernetes/ingress-nginx"

  aad_groups            = local.aad_groups_view
  external_dns_hostname = var.external_dns_hostname
  default_certificate = {
    enabled  = true
    dns_zone = var.cert_manager_config.dns_zone[0]
  }
  namespaces                          = var.namespaces
  private_ingress_enabled             = var.ingress_nginx_config.private_ingress_enabled
  customization                       = var.ingress_nginx_config.customization
  customization_private               = var.ingress_nginx_config.customization_private
  linkerd_enabled                     = var.platform_config.linkerd_enabled
  datadog_enabled                     = var.platform_config.datadog_enabled
  cluster_id                          = local.cluster_id
  replicas                            = var.ingress_nginx_config.replicas
  min_replicas                        = var.ingress_nginx_config.min_replicas
  nginx_healthz_ingress_hostname      = var.cert_manager_config.dns_zone[0]
  nginx_healthz_ingress_whitelist_ips = var.nginx_healthz_ingress_whitelist_ips
  tenant_name                         = var.platform_config.tenant_name
  environment                         = var.environment
  fleet_infra_config                  = var.platform_config.fleet_infra_config
}

module "karpenter" {
  for_each = {
    for s in ["karpenter"] :
    s => s
    if var.platform_config.karpenter_enabled
  }

  source = "../../kubernetes/karpenter"

  aks_config = {
    cluster_id       = local.cluster_id
    cluster_name     = data.azurerm_kubernetes_cluster.this.name
    cluster_endpoint = data.azurerm_kubernetes_cluster.this.kube_config[0].host
    bootstrap_token = join(".", [
      base64decode(data.kubernetes_resources.bootstrap_token.objects[0].data.token-id),
      base64decode(data.kubernetes_resources.bootstrap_token.objects[0].data.token-secret)
    ])
    default_node_pool_size = data.azurerm_kubernetes_cluster.this.agent_pool_profile[0].count
    node_identities        = data.azurerm_kubernetes_cluster.this.kubelet_identity[0].user_assigned_identity_id
    node_resource_group    = data.azurerm_kubernetes_cluster.this.node_resource_group
    oidc_issuer_url        = var.oidc_issuer_url
    ssh_public_key         = data.azurerm_kubernetes_cluster.this.linux_profile[0].ssh_key[0].key_data
    vnet_subnet_id         = data.azurerm_kubernetes_cluster.this.agent_pool_profile[0].vnet_subnet_id
  }

  karpenter_config    = var.karpenter_config
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  subscription_id     = data.azurerm_client_config.current.subscription_id
}

module "linkerd" {
  for_each = {
    for s in ["linkerd"] :
    s => s
    if var.platform_config.linkerd_enabled
  }

  cluster_id         = local.cluster_id
  source             = "../../kubernetes/linkerd"
  tenant_name        = var.platform_config.tenant_name
  environment        = var.environment
  fleet_infra_config = var.platform_config.fleet_infra_config
}

module "litmus" {
  for_each = {
    for s in ["litmus"] :
    s => s
    if var.platform_config.litmus_enabled
  }

  source = "../../kubernetes/litmus"

  azure_key_vault_name          = data.azurerm_key_vault.core.name
  cluster_id                    = local.cluster_id
  key_vault_resource_group_name = data.azurerm_key_vault.core.resource_group_name
  tenant_name                   = var.platform_config.tenant_name
  environment                   = var.environment
  fleet_infra_config            = var.platform_config.fleet_infra_config
}

module "nginx_gateway_fabric" {
  depends_on = [module.gateway_api]

  for_each = {
    for s in ["nginx-gateway"] :
    s => s
    if var.platform_config.nginx_gateway_enabled
  }

  source = "../../kubernetes/nginx-gateway-fabric"

  cluster_id         = local.cluster_id
  gateway_config     = var.nginx_gateway_config
  nginx_config       = var.ingress_nginx_config.customization
  tenant_name        = var.platform_config.tenant_name
  environment        = var.environment
  fleet_infra_config = var.platform_config.fleet_infra_config
}

module "node_ttl" {
  for_each = {
    for s in ["node-ttl"] :
    s => s
    if var.platform_config.node_ttl_enabled
  }

  source = "../../kubernetes/node-ttl"

  cluster_id                  = local.cluster_id
  status_config_map_namespace = "kube-system"
  tenant_name                 = var.platform_config.tenant_name
  environment                 = var.environment
  fleet_infra_config          = var.platform_config.fleet_infra_config
}

module "popeye" {
  for_each = {
    for s in ["popeye"] :
    s => s
    if var.platform_config.popeye_enabled
  }

  source = "../../kubernetes/popeye"

  aks_managed_identity_id = var.platform_config.cilium_enabled ? data.azurerm_kubernetes_cluster.this.identity[0].identity_ids[0] : data.azurerm_kubernetes_cluster.this.identity[0].principal_id
  cluster_id              = local.cluster_id
  location                = data.azurerm_key_vault.core.location
  oidc_issuer_url         = var.oidc_issuer_url
  popeye_config           = var.popeye_config
  resource_group_name     = data.azurerm_resource_group.this.name
  tenant_name             = var.platform_config.tenant_name
  environment             = var.environment
  fleet_infra_config      = var.platform_config.fleet_infra_config
}
/*
module "prometheus" {
  for_each = {
    for s in ["prometheus"] :
    s => s
    if var.platform_config.prometheus_enabled
  }

  source = "../../kubernetes/prometheus"

  aks_name                        = var.name
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

  aad_pod_identity_enabled = var.platform_config.aad_pod_identity_enabled
  cilium_enabled           = var.platform_config.cilium_enabled
  falco_enabled            = var.platform_config.falco_enabled
  gatekeeper_enabled       = var.platform_config.gatekeeper_enabled
  grafana_agent_enabled    = var.platform_config.grafana_agent_enabled
  linkerd_enabled          = var.platform_config.linkerd_enabled
  node_local_dns_enabled   = var.platform_config.node_local_dns_enabled
  node_ttl_enabled         = var.platform_config.node_ttl_enabled
  promtail_enabled         = var.platform_config.promtail_enabled
  spegel_enabled           = var.platform_config.spegel_enabled
  trivy_enabled            = var.platform_config.trivy_enabled
  vpa_enabled              = var.platform_config.vpa_enabled
  tenant_name              = var.platform_config.tenant_name
  fleet_infra_config       = var.platform_config.fleet_infra_config
}

module "promtail" {
  for_each = {
    for s in ["promtail"] :
    s => s
    if var.platform_config.promtail_enabled
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
  tenant_name         = var.platform_config.tenant_name
  fleet_infra_config  = var.platform_config.fleet_infra_config
}
*/
module "rabbitmq_operator" {
  for_each = {
    for s in ["rabbitmq"] :
    s => s
    if var.platform_config.rabbitmq_enabled
  }

  source             = "../../kubernetes/rabbitmq-operator"
  cluster_id         = local.cluster_id
  rabbitmq_config    = var.rabbitmq_config
  tenant_name        = var.platform_config.tenant_name
  environment        = var.environment
  fleet_infra_config = var.platform_config.fleet_infra_config
}

module "reloader" {
  for_each = {
    for s in ["reloader"] :
    s => s
    if var.platform_config.reloader_enabled
  }

  source             = "../../kubernetes/reloader"
  cluster_id         = local.cluster_id
  tenant_name        = var.platform_config.tenant_name
  environment        = var.environment
  fleet_infra_config = var.platform_config.fleet_infra_config
}

module "spegel" {
  for_each = {
    for s in ["spegel"] :
    s => s
    if var.platform_config.spegel_enabled
  }

  source = "../../kubernetes/spegel"

  cluster_id         = local.cluster_id
  private_registry   = "https://${data.azurerm_container_registry.acr.login_server}"
  tenant_name        = var.platform_config.tenant_name
  environment        = var.environment
  fleet_infra_config = var.platform_config.fleet_infra_config
}

module "trivy" {

  for_each = {
    for s in ["trivy"] :
    s => s
    if var.platform_config.trivy_enabled && !var.platform_config.defender_enabled
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
  tenant_name                     = var.platform_config.tenant_name
  fleet_infra_config              = var.platform_config.fleet_infra_config
}

module "velero" {
  for_each = {
    for s in ["velero"] :
    s => s
    if var.platform_config.velero_enabled
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
  tenant_name         = var.platform_config.tenant_name
  fleet_infra_config  = var.platform_config.fleet_infra_config
}

module "vpa" {
  for_each = {
    for s in ["vpa"] :
    s => s
    if var.platform_config.vpa_enabled
  }

  source = "../../kubernetes/vpa"

  cluster_id         = local.cluster_id
  tenant_name        = var.platform_config.tenant_name
  environment        = var.environment
  fleet_infra_config = var.platform_config.fleet_infra_config
}
