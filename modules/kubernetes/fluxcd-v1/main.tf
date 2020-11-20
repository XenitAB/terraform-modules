# Module requirements
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
  helm_release_name = "fluxcd-v1"
  helm_chart_name   = "flux"
}

resource "helm_release" "fluxcd_v1" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  name      = local.helm_release_name
  chart     = "${path.module}/charts/flux"
  namespace = each.key

  values = [templatefile("${path.module}/templates/values.yaml.tpl", { namespace = each.key, git_url = "https://dev.azure.com/${each.value.flux.azdo_org}/${each.value.flux.azdo_project}/_git/${each.value.flux.azdo_repo}", fluxcd_v1_git_path = var.fluxcd_v1_git_path })]


  dynamic "set_sensitive" {
    for_each = {
      for s in ["azdo-proxy"] :
      s => s
      if var.azdo_proxy_enabled == true
    }
    content {
      name  = "git.config.data"
      value = <<EOF
        [url "http://${var.azdo_proxy_local_passwords[each.key]}@azdo-proxy.azdo-proxy"]
          insteadOf = https://dev.azure.com
        EOF
    }
  }
}
