module "cert_manager" {
  source = "github.com/XenitAB/terraform-modules//modules/kubernetes/cert-manager?ref=2020.12.11"

  providers = {
    helm = helm
  }

  notification_email = "DG-Team-DevOps@xenit.se"
}

module "external_dns" {
  source = "github.com/XenitAB/terraform-modules//modules/kubernetes/external-dns?ref=2020.12.11"

  providers = {
    helm = helm
  }

  dns_provider = "aws"
  aws_config = {
    region   = data.aws_region.current.name
    role_arn = aws_iam_role.iamRoleSaExternalDns.arn
  }
}

module "ingress_nginx" {
  source = "github.com/XenitAB/terraform-modules//modules/kubernetes/ingress-nginx?ref=2020.12.11"

  providers = {
    helm = helm
  }
}

module "datadog" {
  source = "github.com/XenitAB/terraform-modules//modules/kubernetes/datadog?ref=2020.12.11"

  providers = {
    helm = helm
  }

  api_key     = data.aws_secretsmanager_secret_version.datadog_api_key.secret_string
  location    = data.aws_region.current.name
  environment = var.environment
}

module "velero" {
  source = "github.com/XenitAB/terraform-modules//modules/kubernetes/velero?ref=2020.12.11"

  providers = {
    helm = helm
  }

  cloud_provider = "aws"
  aws_config = {
    region       = data.aws_region.current.name
    role_arn     = aws_iam_role.iamRoleSaVelero.arn
    s3_bucket_id = aws_s3_bucket.s3BucketVelero.id
  }
}

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

module "opa_gatekeeper" {
  source = "github.com/XenitAB/terraform-modules//modules/kubernetes/opa-gatekeeper?ref=2020.12.11"

  providers = {
    helm = helm
  }

  default_constraints = []
  additional_constraints = [
    {
      kind               = "K8sRequiredAnnotations"
      name               = "ingress-class"
      enforcement_action = "deny"
      match = {
        kinds = [{
          apiGroups = ["extensions", "networking.k8s.io"]
          kinds     = ["Ingress"]
        }]
        namespaces = []
      }
      parameters = {
        message = "All ingress objects must have the annotation `kubernetes.io/ingress.class: nginx`"
        annotations = [{
          key          = "kubernetes.io/ingress.class"
          allowedRegex = "^nginx$"
        }]
      }
    },
    {
      kind               = "K8sRequiredAnnotations"
      name               = "cluster-issuer"
      enforcement_action = "deny"
      match = {
        kinds = [{
          apiGroups = ["extensions", "networking.k8s.io"]
          kinds     = ["Ingress"]
        }]
        namespaces = []
      }
      parameters = {
        message = "All ingress objects must have the annotation `cert-manager.io/cluster-issuer: letsencrypt`"
        annotations = [{
          key          = "cert-manager.io/cluster-issuer"
          allowedRegex = "^letsencrypt-prod$"
        }]
      }
    },
    {
      kind               = "K8sHttpsOnly"
      name               = "ingress-https-only"
      enforcement_action = "deny"
      match = {
        kinds = [{
          apiGroups = ["extensions", "networking.k8s.io"]
          kinds     = ["Ingress"]
        }]
        namespaces = []
      }
      parameters = {
        message     = ""
        annotations = []
      }
    },
  ]
}
