locals {
  excluded_namespaces = ["kube-system", "gatekeeper-system", "cert-manager", "ingress-nginx", "velero", "flux-system", "external-dns", "falco", "reloader", "external-secrets", "calico-system"]
}

module "opa_gatekeeper" {
  for_each = {
    for s in ["opa-gatekeeper"] :
    s => s
    if var.opa_gatekeeper_enabled
  }

  source = "../../kubernetes/opa-gatekeeper"

  excluded_namespaces = local.excluded_namespaces
  cloud_provider      = "aws"
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

  cloud_provider   = "aws"
  multiple_ingress = var.ingress_config.multiple_ingress
}

# ingress-nginx-private
module "ingress_nginx_private" {
  depends_on = [module.opa_gatekeeper, module.linkerd]

  for_each = {
    for s in ["ingress-nginx"] :
    s => s
    if var.ingress_nginx_enabled && var.ingress_config.multiple_ingress
  }

  source = "../../kubernetes/ingress-nginx"

  cloud_provider         = "aws"
  http_snippet           = var.ingress_config.http_snippet
  linkerd_enabled        = var.linkerd_enabled
  internal_load_balancer = var.ingress_config.internal_load_balancer
  name_override          = var.ingress_config.name_override
  multiple_ingress       = var.ingress_config.multiple_ingress
  default_ingress_class  = var.ingress_config.private_default_ingress_class
}

module "ingress_healthz" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["ingress-healthz"] :
    s => s
    if var.ingress_healthz_enabled
  }

  source = "../../kubernetes/ingress-healthz"

  environment     = var.environment
  dns_zone        = var.cert_manager_config.dns_zone
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
  txt_owner_id = var.environment # TODO: Add "name" definition to eks-core as well
  aws_config = {
    region   = data.aws_region.current.name
    role_arn = var.external_dns_config.role_arn
  }
}

module "cert_manager" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["cert-manager"] :
    s => s
    if var.cert_manager_enabled
  }

  source = "../../kubernetes/cert-manager"

  cloud_provider = "aws"
  aws_config = {
    region         = data.aws_region.current.name
    hosted_zone_id = data.aws_route53_zone.this.zone_id
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

  cloud_provider = "aws"

  remote_write_enabled = var.prometheus_config.remote_write_enabled
  remote_write_url     = var.prometheus_config.remote_write_url
  tenant_id            = var.prometheus_config.tenant_id

  volume_claim_enabled            = var.prometheus_config.volume_claim_enabled
  volume_claim_storage_class_name = var.prometheus_config.volume_claim_storage_class_name
  volume_claim_size               = var.prometheus_config.volume_claim_size

  alertmanager_enabled = var.prometheus_config.alertmanager_enabled

  cluster_name       = "${var.name}${var.eks_name_suffix}"
  environment        = var.environment
  resource_selector  = var.prometheus_config.resource_selector
  namespace_selector = var.prometheus_config.namespace_selector

  falco_enabled                            = var.falco_enabled
  opa_gatekeeper_enabled                   = var.opa_gatekeeper_enabled
  linkerd_enabled                          = var.linkerd_enabled
  goldpinger_enabled                       = var.goldpinger_enabled
  flux_system_enabled                      = var.flux_system_enabled
  aad_pod_identity_enabled                 = false
  csi_secrets_store_provider_azure_enabled = false
  csi_secrets_store_provider_aws_enabled   = var.csi_secrets_store_provider_aws_enabled
}

module "cluster_autoscaler" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["cluster-autoscaler"] :
    s => s
    if var.cluster_autoscaler_enabled
  }

  source = "../../kubernetes/cluster-autoscaler"

  cluster_name   = "${var.name}${var.eks_name_suffix}"
  cloud_provider = "aws"
  aws_config = {
    region   = data.aws_region.current.name
    role_arn = var.cluster_autoscaler_config.role_arn
  }
}

module "csi_secrets_store_provider_aws" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["csi-secrets-store-provider-aws"] :
    s => s
    if var.csi_secrets_store_provider_aws_enabled
  }

  source = "../../kubernetes/csi-secrets-store-provider-aws"
}

module "xenit" {
  for_each = {
    for s in ["xenit"] :
    s => s
    if var.xenit_enabled
  }

  source = "../../kubernetes/xenit"

  cloud_provider = "aws"
  aws_config = {
    role_arn = var.xenit_config.role_arn
  }
  thanos_receiver_fqdn = var.xenit_config.thanos_receiver
  loki_api_fqdn        = var.xenit_config.loki_api
}

module "goldpinger" {
  depends_on = [module.opa_gatekeeper, module.linkerd]

  for_each = {
    for s in ["goldpinger"] :
    s => s
    if var.goldpinger_enabled
  }

  source = "../../kubernetes/goldpinger"

  linkerd_enabled = var.linkerd_enabled
}
