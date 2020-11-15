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

resource "helm_release" "helm_operator" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }

  repository = var.helm_operator_helm_repository
  chart      = var.helm_operator_helm_chart_name
  version    = var.helm_operator_helm_chart_version
  name       = var.helm_operator_helm_release_name
  namespace  = each.key

  set {
    name  = "allowNamespace"
    value = each.key
  }

  set {
    name  = "clusterRole.create"
    value = "false"
  }

  set {
    name  = "helm.versions"
    value = "v3"
  }

  set {
    name  = "configureRepositories.enable"
    value = "true"
  }

  set {
    name  = "configureRepositories.repositories[0].name"
    value = "AzureContainerRegistry"
  }

  set {
    name  = "configureRepositories.repositories[0].url"
    value = "https://${var.acr_name}.azurecr.io/helm/v1/repo/"
  }

  set {
    name  = "configureRepositories.repositories[0].username"
    value = var.helm_operator_credentials.client_id
  }

  set {
    name  = "configureRepositories.repositories[0].password"
    value = var.helm_operator_credentials.secret
  }

  set {
    name  = "git.config.enabled"
    value = "true"
  }

  set {
    name  = "git.config.secretName"
    value = "helm-operator-git-config"
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
        [url "http://${var.azdo_proxy_local_passwords[each.key]}@azdo-proxy.azdo-proxy"]
          insteadOf = https://dev.azure.com
        EOF
    }
  }
}
