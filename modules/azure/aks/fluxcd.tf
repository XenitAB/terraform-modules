resource "helm_release" "fluxcd_v1" {
  depends_on = [kubernetes_namespace.group]
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.flux.enabled
  }

  name       = "flux"
  repository = "https://charts.fluxcd.io"
  chart      = "flux"
  version    = "1.3.0"
  namespace  = each.key

  set {
    name  = "allowNamespaces[0]"
    value = each.key
  }

  set {
    name  = "clusterRole.create"
    value = "false"
  }

  set {
    name  = "git.url"
    value = "https://dev.azure.com/${each.value.flux.azdo_org}/${each.value.flux.azdo_project}/_git/${each.value.flux.azdo_repo}"
  }

  set {
    name  = "git.path"
    value = var.environment
  }

  set {
    name  = "git.readonly"
    value = "true"
  }

  set {
    name  = "git.config.enabled"
    value = "true"
  }

  set {
    name  = "git.config.secretName"
    value = "flux-git-config"
  }

  dynamic "set" {
    for_each = {
      for s in ["azdo-proxy"] :
      s => s
      if var.azdo_proxy_enabled == true
    }
    content {
      name  = "git.config.data"
      value = <<EOF
        [url "http://${module.azdo_proxy["azdo-proxy"].azdo_proxy_local_passwords[each.key]}@azdo-proxy.azdo-proxy"]
          insteadOf = https://dev.azure.com
        EOF
    }
  }

  set {
    name  = "git.pollInterval"
    value = "30s"
  }

  set {
    name  = "registry.disableScanning"
    value = "true"
  }

  set {
    name  = "memcached.enabled"
    value = "false"
  }

  set {
    name  = "syncGarbageCollection.enabled"
    value = "true"
  }
}
