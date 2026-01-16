terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azuread = {
      version = "2.50.0"
      source  = "hashicorp/azuread"
    }
    azurerm = {
      version = "4.57.0"
      source  = "hashicorp/azurerm"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "core" {
  resource_group_name = var.core_resource_group_name
  name                = var.key_vault_name
}

data "azurerm_key_vault_secret" "key" {
  for_each = tomap({
    for secret in local.key_vault_secret_names : secret => secret
  })
  name         = each.key
  key_vault_id = data.azurerm_key_vault.core.id
}


resource "kubernetes_namespace" "argocd" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if contains(["Hub", "Hub-Spoke"], var.argocd_config.cluster_role)
  }

  metadata {
    name = "argocd"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }
}

resource "helm_release" "argocd" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if contains(["Hub"], var.argocd_config.cluster_role)
  }

  depends_on  = [kubernetes_namespace.argocd]
  chart       = "oci://ghcr.io/argoproj/argo-helm/argo-cd"
  name        = "argo-cd"
  namespace   = "argocd"
  version     = "8.3.7"
  max_history = 3

  values = [templatefile("${path.module}/templates/argocd-values.yaml.tpl", {
    client_id                       = azurerm_user_assigned_identity.argocd.client_id
    tenant_id                       = azurerm_user_assigned_identity.argocd.tenant_id
    controller_replicas             = var.argocd_config.controller_replicas
    server_replicas                 = var.argocd_config.server_replicas
    repo_server_replicas            = var.argocd_config.repo_server_replicas
    application_set_replicas        = var.argocd_config.application_set_replicas
    dynamic_sharding                = var.argocd_config.dynamic_sharding
    controller_status_processors    = var.argocd_config.controller_status_processors
    controller_operation_processors = var.argocd_config.controller_operation_processors
    argocd_k8s_client_qps           = var.argocd_config.argocd_k8s_client_qps
    argocd_k8s_client_burst         = var.argocd_config.argocd_k8s_client_burst
    ingress_whitelist_ip            = var.argocd_config.ingress_whitelist_ip
    global_domain                   = var.argocd_config.global_domain
    dex_tenant_name                 = var.argocd_config.dex_tenant_name
    dex_client_id                   = azuread_application.dex["argocd"].client_id
    dex_client_secret               = azuread_application_password.dex["argocd"].value
    aad_group_name                  = var.argocd_config.aad_group_name
    azure_tenants                   = var.argocd_config.azure_tenants
    application_namespaces          = local.application_namespaces
  })]
}

resource "git_repository_file" "argocd_chart" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if var.argocd_config.cluster_role == "Hub-Spoke"
  }

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/argocd/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "argocd_values" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if var.argocd_config.cluster_role == "Hub-Spoke"
  }

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/argocd/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "argocd_app" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if var.argocd_config.cluster_role == "Hub-Spoke"
  }

  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/argocd-app.yaml"
  content = templatefile("${path.module}/templates/argocd-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "argocd" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if var.argocd_config.cluster_role == "Hub-Spoke"
  }

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/argocd/templates/argocd.yaml"
  content = templatefile("${path.module}/templates/argocd.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    values = indent(8, templatefile("${path.module}/templates/argocd-values.yaml.tpl", {
      client_id                       = azurerm_user_assigned_identity.argocd.client_id
      tenant_id                       = azurerm_user_assigned_identity.argocd.tenant_id
      controller_replicas             = var.argocd_config.controller_replicas
      server_replicas                 = var.argocd_config.server_replicas
      repo_server_replicas            = var.argocd_config.repo_server_replicas
      application_set_replicas        = var.argocd_config.application_set_replicas
      dynamic_sharding                = var.argocd_config.dynamic_sharding
      controller_status_processors    = var.argocd_config.controller_status_processors
      controller_operation_processors = var.argocd_config.controller_operation_processors
      argocd_k8s_client_qps           = var.argocd_config.argocd_k8s_client_qps
      argocd_k8s_client_burst         = var.argocd_config.argocd_k8s_client_burst
      ingress_whitelist_ip            = var.argocd_config.ingress_whitelist_ip
      global_domain                   = var.argocd_config.global_domain
      dex_tenant_name                 = var.argocd_config.dex_tenant_name
      dex_client_id                   = azuread_application.dex["argocd"].client_id
      dex_client_secret               = azuread_application_password.dex["argocd"].value
      aad_group_name                  = var.argocd_config.aad_group_name
      azure_tenants                   = var.argocd_config.azure_tenants
      application_namespaces          = local.application_namespaces
    }))
  })
}

resource "git_repository_file" "argocd_extras" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if var.argocd_config.cluster_role == "Hub-Spoke"
  }

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/argocd/templates/argocd-extras.yaml"
  content = templatefile("${path.module}/templates/argocd-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "argocd_extras_manifests" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if var.argocd_config.cluster_role == "Hub-Spoke"
  }

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/argocd/manifests/argocd-extras.yaml"
  content = templatefile("${path.module}/templates/argocd-hub-manifests.yaml.tpl", {
    azure_tenants  = var.argocd_config.azure_tenants
    sync_windows   = var.argocd_config.sync_windows
    key_vault_name = var.key_vault_name
    tenant_id      = data.azurerm_client_config.current.tenant_id
    uai_id         = azurerm_user_assigned_identity.argocd.principal_id
    vault_url      = data.azurerm_key_vault.core.vault_uri
  })
}
