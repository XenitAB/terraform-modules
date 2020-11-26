/**
  * # External Secrets
  *
  * Adds [`external-secrets`](https://github.com/external-secrets/kubernetes-external-secrets) to a Kubernetes clusters.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

locals {
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    aws_config = var.aws_config
  })
}

resource "helm_release" "external_secrets" {
  repository       = "https://external-secrets.github.io/kubernetes-external-secrets/"
  chart            = "kubernetes-external-secrets"
  name             = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
  skip_crds        = true # let the custom resource manager install the CRDs
  version          = "6.0.0"
  values           = [local.values]
}
