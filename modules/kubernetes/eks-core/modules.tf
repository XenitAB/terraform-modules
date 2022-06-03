locals {
  excluded_namespaces = [
    "calico-system",
    "cert-manager",
    "csi-secrets-store-provider-aws",
    "datadog",
    "external-dns",
    "falco",
    "flux-system",
    "gatekeeper-system",
    "ingress-nginx",
    "kube-system",
    "prometheus",
    "reloader",
    "velero",
    "promtail"
  ]
  dns_zone = {
    for dns in data.aws_route53_zone.this :
    dns.name => dns.zone_id
  }
}

data "aws_route53_zone" "this" {
  for_each = {
    for dns in var.cert_manager_config.dns_zone :
    dns => dns
  }
  name = each.key
}

module "opa_gatekeeper_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart_name       = "gatekeeper"
  chart_version    = "3.7.1"
}

module "opa_gatekeeper" {
  depends_on = [module.opa_gatekeeper_crd]

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
        kind               = "K8sPodPriorityClass"
        name               = "pod-priority-class"
        enforcement_action = ""
        match = {
          kinds      = []
          namespaces = []
        }
        parameters = {
          permittedClassNames = ["platform-high", "platform-medium", "platform-low", "tenant-high", "tenant-medium", "tenant-low"]
        }
      },
    ]
  )
  enable_default_assigns = var.opa_gatekeeper_config.enable_default_assigns
  excluded_namespaces    = concat(var.opa_gatekeeper_config.additional_excluded_namespaces, local.excluded_namespaces)
  cloud_provider         = "aws"
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
  cluster_id        = "${data.aws_region.current.name}-${var.environment}-${var.name}${var.eks_name_suffix}"
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
  cluster_id             = "${data.aws_region.current.name}-${var.environment}-${var.name}${var.eks_name_suffix}"
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

module "linkerd" {
  depends_on = [module.opa_gatekeeper, module.cert_manager]

  for_each = {
    for s in ["linkerd"] :
    s => s
    if var.linkerd_enabled
  }

  source = "../../kubernetes/linkerd"
}

module "ingress_nginx" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["ingress-nginx"] :
    s => s
    if var.ingress_nginx_enabled
  }

  source = "../../kubernetes/ingress-nginx"

  cloud_provider            = "aws"
  http_snippet              = var.ingress_config.http_snippet
  linkerd_enabled           = var.linkerd_enabled
  datadog_enabled           = var.datadog_enabled
  public_private_enabled    = var.ingress_config.public_private_enabled
  allow_snippet_annotations = var.ingress_config.allow_snippet_annotations

  default_certificate = {
    enabled  = true
    dns_zone = var.cert_manager_config.dns_zone[0]
  }
}

module "ingress_healthz" {
  depends_on = [module.opa_gatekeeper, module.ingress_nginx]

  for_each = {
    for s in ["ingress-healthz"] :
    s => s
    if var.ingress_healthz_enabled
  }

  source = "../../kubernetes/ingress-healthz"

  environment     = var.environment
  dns_zone        = var.cert_manager_config.dns_zone[0]
  linkerd_enabled = var.linkerd_enabled
}

module "external_dns" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["external-dns"] :
    s => s
    if var.external_dns_enabled
  }

  source = "../../kubernetes/external-dns"

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
  depends_on = [module.opa_gatekeeper, module.cert_manager_crd]

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
  depends_on = [module.opa_gatekeeper]

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
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["falco"] :
    s => s
    if var.falco_enabled
  }

  source = "../../kubernetes/falco"

  cloud_provider = "aws"
}

module "reloader" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["reloader"] :
    s => s
    if var.reloader_enabled
  }

  source = "../../kubernetes/reloader"
}

module "azad_kube_proxy" {
  depends_on = [module.ingress_nginx]

  for_each = {
    for s in ["azad-kube-proxy"] :
    s => s
    if var.azad_kube_proxy_enabled
  }

  source = "../../kubernetes/azad-kube-proxy"

  fqdn                  = var.azad_kube_proxy_config.fqdn
  azure_ad_group_prefix = var.azad_kube_proxy_config.azure_ad_group_prefix
  allowed_ips           = var.azad_kube_proxy_config.allowed_ips

  azure_ad_app = {
    client_id     = var.azad_kube_proxy_config.azure_ad_app.client_id
    client_secret = var.azad_kube_proxy_config.azure_ad_app.client_secret
    tenant_id     = var.azad_kube_proxy_config.azure_ad_app.tenant_id
  }
}

# Promtail
module "promtail" {
  depends_on = [module.opa_gatekeeper]

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
  tenant_id           = var.prometheus_config.tenant_id
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
  chart_version    = "35.4.2"
}

module "prometheus" {
  depends_on = [module.opa_gatekeeper, module.prometheus_crd]

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

  remote_write_authenticated = var.prometheus_config.remote_write_authenticated
  remote_write_url           = var.prometheus_config.remote_write_url

  volume_claim_storage_class_name = "gp2"
  volume_claim_size               = var.prometheus_config.volume_claim_size

  resource_selector  = var.prometheus_config.resource_selector
  namespace_selector = var.prometheus_config.namespace_selector

  falco_enabled                          = var.falco_enabled
  opa_gatekeeper_enabled                 = var.opa_gatekeeper_enabled
  linkerd_enabled                        = var.linkerd_enabled
  flux_enabled                           = var.fluxcd_v2_enabled
  csi_secrets_store_provider_aws_enabled = var.csi_secrets_store_provider_aws_enabled
  azad_kube_proxy_enabled                = var.azad_kube_proxy_enabled
  starboard_enabled                      = var.starboard_enabled
  vpa_enabled                            = var.vpa_enabled
  node_local_dns_enabled                 = var.node_local_dns_enabled
  promtail_enabled                       = var.promtail_enabled
}

# starboard
module "starboard_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://aquasecurity.github.io/helm-charts/"
  chart_name       = "starboard-operator"
  chart_version    = "0.9.1"
}

module "starboard" {
  depends_on = [module.opa_gatekeeper, module.starboard_crd]

  for_each = {
    for s in ["starboard"] :
    s => s
    if var.starboard_enabled
  }

  source = "../../kubernetes/starboard"

  cloud_provider                  = "aws"
  starboard_role_arn              = var.starboard_config.starboard_role_arn
  trivy_role_arn                  = var.starboard_config.trivy_role_arn
  volume_claim_storage_class_name = "gp2"
}

module "cluster_autoscaler" {
  depends_on = [module.opa_gatekeeper]

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
  chart_version    = "1.1.2"
}

module "csi_secrets_store_provider_aws" {
  depends_on = [module.csi_secrets_store_provider_aws_crd, module.opa_gatekeeper]

  for_each = {
    for s in ["csi-secrets-store-provider-aws"] :
    s => s
    if var.csi_secrets_store_provider_aws_enabled
  }

  source = "../../kubernetes/csi-secrets-store-provider-aws"
}

# datadog
module "datadog_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://helm.datadoghq.com"
  chart_name       = "datadog-operator"
  chart_version    = "0.8.0"
}

module "datadog" {
  depends_on = [module.opa_gatekeeper, module.datadog_crd]

  for_each = {
    for s in ["datadog"] :
    s => s
    if var.datadog_enabled
  }

  source = "../../kubernetes/datadog"

  location          = data.aws_region.current.name
  environment       = var.environment
  datadog_site      = var.datadog_config.datadog_site
  api_key           = var.datadog_config.api_key
  app_key           = var.datadog_config.app_key
  namespace_include = var.datadog_config.namespaces
}

# vpa
module "vpa_crd" {
  source = "../../kubernetes/helm-crd"

  chart_repository = "https://charts.fairwinds.com/stable"
  chart_name       = "goldilocks"
  chart_version    = "5.1.0"
}

module "vpa" {
  depends_on = [module.opa_gatekeeper, module.vpa_crd]

  for_each = {
    for s in ["vpa"] :
    s => s
    if var.vpa_enabled
  }

  source = "../../kubernetes/vpa"
}

module "node_local_dns" {
  depends_on = [module.opa_gatekeeper, module.prometheus]

  for_each = {
    for s in ["node-local-dns"] :
    s => s
    if var.node_local_dns_enabled
  }

  source = "../../kubernetes/node-local-dns"
  dns_ip = var.node_local_dns_dns_ip
}

module "node_ttl" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["node-ttl"] :
    s => s
    if var.node_ttl_enabled
  }

  source = "../../kubernetes/node-ttl"
}
