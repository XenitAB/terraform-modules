locals {
  excluded_namespaces = ["kube-system", "gatekeeper-system", "cert-manager", "ingress-nginx", "velero", "flux-system", "external-dns", "external-secrets", "kyverno"]
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
}

# Fluxcd
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

# External Secrets
module "external_secrets" {
  depends_on = [module.opa_gatekeeper]

  for_each = {
    for s in ["external-secrets"] :
    s => s
    if var.external_secrets_enabled
  }

  source = "../../kubernetes/external-secrets"

  aws_config = {
    region   = data.aws_region.current.name
    role_arn = var.external_secrets_config.role_arn
  }
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

# Cert Manager
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

# Velero
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
