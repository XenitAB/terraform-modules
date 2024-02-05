locals {
  exclude_namespaces = [
    "calico-system",
    "cert-manager",
    "csi-secrets-store-provider-aws",
    "datadog",
    "external-dns",
    "falco",
    "flux-system",
    "ingress-nginx",
    "ingress-healthz",
    "prometheus",
    "reloader",
    "velero",
    "promtail",
    "node-ttl",
    "spegel",
    "vpa",
  ]
  dns_zone = {
    for dns in data.aws_route53_zone.this :
    dns.name => dns.zone_id
  }
  cluster_id = "${data.aws_region.current.name}-${var.environment}-${var.name}${var.eks_name_suffix}"
}

data "aws_route53_zone" "this" {
  for_each = {
    for dns in var.cert_manager_config.dns_zone :
    dns => dns
  }
  name = each.key
}

module "gatekeeper" {
  for_each = {
    for s in ["gatekeeper"] :
    s => s
    if var.gatekeeper_enabled
  }

  source = "../../kubernetes/gatekeeper"

  cluster_id         = local.cluster_id
  cloud_provider     = "aws"
  exclude_namespaces = concat(var.gatekeeper_config.exclude_namespaces, local.exclude_namespaces)
}

# FluxCD v2
module "fluxcd_v2_azure_devops" {
  for_each = {
    for s in ["fluxcd-v2"] :
    s => s
    if var.fluxcd_v2_enabled && var.fluxcd_v2_config.type == "azure-devops"
  }

  source = "../../kubernetes/fluxcd-v2-azdo"

  environment       = var.environment
  cluster_id        = local.cluster_id
  azure_devops_pat  = var.fluxcd_v2_config.azure_devops.pat
  azure_devops_org  = var.fluxcd_v2_config.azure_devops.org
  azure_devops_proj = var.fluxcd_v2_config.azure_devops.proj
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
}

module "fluxcd_v2_github" {
  for_each = {
    for s in ["fluxcd-v2"] :
    s => s
    if var.fluxcd_v2_enabled && var.fluxcd_v2_config.type == "github"
  }

  source = "../../kubernetes/fluxcd-v2-github"

  environment            = var.environment
  cluster_id             = local.cluster_id
  github_org             = var.fluxcd_v2_config.github.org
  github_app_id          = var.fluxcd_v2_config.github.app_id
  github_installation_id = var.fluxcd_v2_config.github.installation_id
  github_private_key     = var.fluxcd_v2_config.github.private_key
  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = {
      enabled = ns.flux.enabled
      repo    = ns.flux.github.repo
    }
  }]
}

# linkerd
module "linkerd_crd" {
  source = "../../kubernetes/helm-crd"

  for_each = {
    for s in ["linkerd"] :
    s => s
    if var.linkerd_enabled
  }

  chart_repository = "https://helm.linkerd.io/edge"
  chart_name       = "linkerd-crds"
  chart_version    = "1.1.1-edge"
}

module "linkerd" {
  depends_on = [module.cert_manager, module.linkerd_crd]

  for_each = {
    for s in ["linkerd"] :
    s => s
    if var.linkerd_enabled
  }

  source = "../../kubernetes/linkerd"
}

module "ingress_nginx" {
  for_each = {
    for s in ["ingress-nginx"] :
    s => s
    if var.ingress_nginx_enabled
  }

  source = "../../kubernetes/ingress-nginx"

  cloud_provider = "aws"
  default_certificate = {
    enabled  = true
    dns_zone = var.cert_manager_config.dns_zone[0]
  }
  public_private_enabled = var.ingress_nginx_config.public_private_enabled
  customization          = var.ingress_nginx_config.customization
  customization_public   = var.ingress_nginx_config.customization_public
  customization_private  = var.ingress_nginx_config.customization_private
  linkerd_enabled        = var.linkerd_enabled
  datadog_enabled        = var.datadog_enabled
}

module "ingress_healthz" {
  depends_on = [module.ingress_nginx]

  for_each = {
    for s in ["ingress-healthz"] :
    s => s
    if var.ingress_healthz_enabled
  }

  source = "../../kubernetes/ingress-healthz"

  environment            = var.environment
  dns_zone               = var.cert_manager_config.dns_zone[0]
  linkerd_enabled        = var.linkerd_enabled
  public_private_enabled = var.ingress_nginx_config.public_private_enabled
  cluster_id             = local.cluster_id
}

module "external_dns" {
  for_each = {
    for s in ["external-dns"] :
    s => s
    if var.external_dns_enabled
  }

  source = "../../kubernetes/external-dns"

  cluster_id   = local.cluster_id
  dns_provider = "aws"
  txt_owner_id = "${var.environment}-${var.name}${var.eks_name_suffix}"
  aws_config = {
    region   = data.aws_region.current.name
    role_arn = var.external_dns_config.role_arn
  }
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

module "cert_manager" {
  depends_on = [module.cert_manager_crd]

  for_each = {
    for s in ["cert-manager"] :
    s => s
    if var.cert_manager_enabled
  }

  source = "../../kubernetes/cert-manager"

  cloud_provider = "aws"
  aws_config = {
    region         = data.aws_region.current.name
    hosted_zone_id = local.dns_zone
    role_arn       = var.cert_manager_config.role_arn
  }
  notification_email = var.cert_manager_config.notification_email
}

module "velero" {
  for_each = {
    for s in ["velero"] :
    s => s
    if var.velero_enabled
  }

  source = "../../kubernetes/velero"

  cloud_provider = "aws"
  aws_config = {
    region       = data.aws_region.current.name
    role_arn     = var.velero_config.role_arn
    s3_bucket_id = var.velero_config.s3_bucket_id
  }
}

module "falco" {
  for_each = {
    for s in ["falco"] :
    s => s
    if var.falco_enabled
  }

  source = "../../kubernetes/falco"

  cloud_provider = "aws"
  cluster_id     = local.cluster_id
}

module "reloader" {
  for_each = {
    for s in ["reloader"] :
    s => s
    if var.reloader_enabled
  }

  source = "../../kubernetes/reloader"
}

module "azad_kube_proxy" {
  for_each = {
    for s in ["azad-kube-proxy"] :
    s => s
    if var.azad_kube_proxy_enabled
  }

  source                = "../../kubernetes/azad-kube-proxy"
  cluster_id            = local.cluster_id
  fqdn                  = var.azad_kube_proxy_config.fqdn
  azure_ad_group_prefix = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}"
  allowed_ips           = var.azad_kube_proxy_config.allowed_ips

  azure_ad_app = {
    client_id     = var.azad_kube_proxy_config.azure_ad_app.client_id
    client_secret = var.azad_kube_proxy_config.azure_ad_app.client_secret
    tenant_id     = var.azad_kube_proxy_config.azure_ad_app.tenant_id
  }
}

# Promtail
module "promtail" {
  for_each = {
    for s in ["promtail"] :
    s => s
    if var.promtail_enabled
  }

  source              = "../../kubernetes/promtail"
  loki_address        = var.promtail_config.loki_address
  cloud_provider      = "aws"
  cluster_name        = "${var.name}${var.eks_name_suffix}"
  environment         = var.environment
  region              = data.aws_region.current.name
  excluded_namespaces = var.promtail_config.excluded_namespaces

  aws_config = {
    role_arn = var.promtail_config.role_arn
  }
}

# Prometheus
module "prometheus_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://prometheus-community.github.io/helm-charts"
  chart_name       = "kube-prometheus-stack"
  chart_version    = "42.1.1"
}

module "prometheus" {
  depends_on = [module.prometheus_crd]

  for_each = {
    for s in ["prometheus"] :
    s => s
    if var.prometheus_enabled
  }

  source = "../../kubernetes/prometheus"

  cloud_provider = "aws"
  aws_config = {
    role_arn = var.prometheus_config.role_arn
  }

  cluster_name = "${var.name}${var.eks_name_suffix}"
  environment  = var.environment
  tenant_id    = var.prometheus_config.tenant_id
  region       = data.aws_region.current.name

  remote_write_authenticated = var.prometheus_config.remote_write_authenticated
  remote_write_url           = var.prometheus_config.remote_write_url

  volume_claim_storage_class_name = "gp2"
  volume_claim_size               = var.prometheus_config.volume_claim_size

  resource_selector  = var.prometheus_config.resource_selector
  namespace_selector = var.prometheus_config.namespace_selector

  falco_enabled                          = var.falco_enabled
  gatekeeper_enabled                     = var.gatekeeper_enabled
  linkerd_enabled                        = var.linkerd_enabled
  flux_enabled                           = var.fluxcd_v2_enabled
  csi_secrets_store_provider_aws_enabled = var.csi_secrets_store_provider_aws_enabled
  azad_kube_proxy_enabled                = var.azad_kube_proxy_enabled
  trivy_enabled                          = var.trivy_enabled
  vpa_enabled                            = var.vpa_enabled
  node_local_dns_enabled                 = var.node_local_dns_enabled
  promtail_enabled                       = var.promtail_enabled
  node_ttl_enabled                       = var.node_ttl_enabled
  spegel_enabled                         = var.spegel_enabled
}

# trivy
module "trivy_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://aquasecurity.github.io/helm-charts/"
  chart_name       = "trivy-operator"
  chart_version    = "0.11.0"
}

module "trivy" {
  depends_on = [module.trivy_crd]

  for_each = {
    for s in ["trivy"] :
    s => s
    if var.trivy_enabled
  }

  source = "../../kubernetes/trivy"

  cloud_provider                  = "aws"
  trivy_operator_role_arn         = var.trivy_config.trivy_operator_role_arn
  trivy_role_arn                  = var.trivy_config.trivy_role_arn
  volume_claim_storage_class_name = "gp2"
}

module "cluster_autoscaler" {
  for_each = {
    for s in ["cluster-autoscaler"] :
    s => s
    if var.cluster_autoscaler_enabled
  }

  source = "../../kubernetes/cluster-autoscaler"

  cluster_name   = "${var.environment}-${var.name}${var.eks_name_suffix}"
  cloud_provider = "aws"
  aws_config = {
    region   = data.aws_region.current.name
    role_arn = var.cluster_autoscaler_config.role_arn
  }
}

module "csi_secrets_store_provider_aws_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart_name       = "secrets-store-csi-driver"
  chart_version    = "1.3.2"
}

module "csi_secrets_store_provider_aws" {
  depends_on = [module.csi_secrets_store_provider_aws_crd]

  for_each = {
    for s in ["csi-secrets-store-provider-aws"] :
    s => s
    if var.csi_secrets_store_provider_aws_enabled
  }

  source = "../../kubernetes/csi-secrets-store-provider-aws"
}

# datadog
module "datadog" {
  for_each = {
    for s in ["datadog"] :
    s => s
    if var.datadog_enabled
  }

  source = "../../kubernetes/datadog"

  cloud_provider = "aws"

  aws_config = {
    role_arn = var.datadog_config.role_arn
  }

  location             = data.aws_region.current.name
  environment          = var.environment
  datadog_site         = var.datadog_config.datadog_site
  namespace_include    = var.datadog_config.namespaces
  apm_ignore_resources = var.datadog_config.apm_ignore_resources
  cluster_id           = local.cluster_id
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

module "node_local_dns" {
  depends_on = [module.prometheus]

  for_each = {
    for s in ["node-local-dns"] :
    s => s
    if var.node_local_dns_enabled
  }

  source = "../../kubernetes/node-local-dns"

  cluster_id = local.cluster_id
  dns_ip     = "172.20.0.10"
}

module "node_ttl" {
  for_each = {
    for s in ["node-ttl"] :
    s => s
    if var.node_ttl_enabled
  }

  source = "../../kubernetes/node-ttl"

  cluster_id                  = local.cluster_id
  status_config_map_namespace = "cluster-autoscaler"
}

module "spegel" {
  for_each = {
    for s in ["spegel"] :
    s => s
    if var.spegel_enabled
  }

  source = "../../kubernetes/spegel"

  cluster_id = local.cluster_id
}
