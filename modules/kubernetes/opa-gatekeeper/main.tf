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
  values                     = templatefile("${path.module}/templates/gatekeeper-library-values.yaml.tpl", { constraints = concat(var.default_constraints, var.additional_constraints), exclude = var.exclude })
  gatekeeper_version         = "v3.2.1"
  gatekeeper_library_version = "v0.4.2"
}

resource "helm_release" "gatekeeper" {
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  name       = "gatekeeper"
  version    = local.gatekeeper_version
}

resource "helm_release" "gatekeeper_templates" {
  depends_on = [helm_release.gatekeeper]

  repository = "https://xenitab.github.io/gatekeeper-library/"
  chart      = "gatekeeper-library-templates"
  name       = "gatekeeper-library-templates"
  namespace  = "gatekeeper-system"
  version    = local.gatekeeper_library_version
  values     = [local.values]
}

resource "helm_release" "gatekeeper_constraints" {
  depends_on = [helm_release.gatekeeper, helm_release.gatekeeper_templates]

  repository = "https://xenitab.github.io/gatekeeper-library/"
  chart      = "gatekeeper-library-constraints"
  name       = "gatekeeper-library-constraints"
  namespace  = "gatekeeper-system"
  version    = local.gatekeeper_library_version
  values     = [local.values]
}
