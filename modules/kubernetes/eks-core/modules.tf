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
      excluded_namespaces = ["kube-system", "gatekeeper-system", "cert-manager", "ingress-nginx", "velero", "azdo-proxy", "flux-system", "external-dns"]
      processes           = ["*"]
    }
  ]
}

# External Secrets
module "external_secrets" {
  source = "github.com/XenitAB/terraform-modules//modules/kubernetes/external-secrets?ref=2020.12.11"

  providers = {
    helm = helm
  }

  aws_config = {
    region   = data.aws_region.current.name
    role_arn = aws_iam_role.iamRoleSaExternalSecrets.arn
  }
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

  dns_provider = "aws"
  aws_config = {
    region   = data.aws_region.current.name
    role_arn = aws_iam_role.iamRoleSaExternalDns.arn
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
    role_arn     = aws_iam_role.iamRoleSaVelero.arn
    s3_bucket_id = aws_s3_bucket.s3BucketVelero.id
  }
}
