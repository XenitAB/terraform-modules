locals {
  azad_kube_proxy_url = var.azad_kube_proxy_config.proxy_url_override == "" ? "https://aks.${var.dns_zone[0]}" : var.azad_kube_proxy_config.proxy_url_override
}

resource "azuread_application" "azad_kube_proxy" {
  for_each = {
    for s in ["azad-kube-proxy"] :
    s => s
    if var.azad_kube_proxy_config.enabled
  }

  display_name = "${var.azad_kube_proxy_config.cluster_name_prefix}-${var.environment}"
  identifier_uris = [
    local.azad_kube_proxy_url
  ]

  api {
    requested_access_token_version = 2
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61" # Directory.Read.All
      type = "Role"
    }
  }

  tags = [
    "azad-kube-proxy",
    "cluster_name:${var.azad_kube_proxy_config.cluster_name_prefix}-${var.environment}",
    "proxy_url:${local.azad_kube_proxy_url}",
  ]
}

resource "azuread_application_password" "azad_kube_proxy" {
  for_each = {
    for s in ["azad-kube-proxy"] :
    s => s
    if var.azad_kube_proxy_config.enabled
  }

  application_object_id = azuread_application.azad_kube_proxy["azad-kube-proxy"].object_id
}

resource "azuread_application_pre_authorized" "azad_kube_proxy_azure_cli" {
  for_each = {
    for s in ["azad-kube-proxy"] :
    s => s
    if var.azad_kube_proxy_config.enabled
  }

  application_object_id = azuread_application.azad_kube_proxy["azad-kube-proxy"].object_id
  authorized_app_id     = "04b07795-8ddb-461a-bbee-02f9e1bf7b46" # Azure CLI
  permission_ids        = azuread_application.azad_kube_proxy["azad-kube-proxy"].oauth2_permission_scope_ids
}
