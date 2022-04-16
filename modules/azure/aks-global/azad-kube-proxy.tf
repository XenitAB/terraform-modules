data "azuread_application_published_app_ids" "well_known" {}
resource "random_uuid" "azad_kube_proxy_oauth2_permission_scope_user_impersonation" {

}
resource "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing   = true
}

locals {
  azad_kube_proxy_url = var.azad_kube_proxy_config.proxy_url_override == "" ? "https://aks.${var.dns_zone[0]}" : var.azad_kube_proxy_config.proxy_url_override
}

resource "azuread_application" "azad_kube_proxy" {
  display_name = "${var.azad_kube_proxy_config.cluster_name_prefix}-${var.environment}"
  identifier_uris = [
    local.azad_kube_proxy_url
  ]

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access azad-kube-proxy on behalf of the signed-in user."
      admin_consent_display_name = "Access azad-kube-proxy"
      enabled                    = true
      id                         = random_uuid.azad_kube_proxy_oauth2_permission_scope_user_impersonation.result
      type                       = "User"
      user_consent_description   = "Allow the application to access azad-kube-proxy on your behalf."
      user_consent_display_name  = "Access azad-kube-proxy"
      value                      = "user_impersonation"
    }
  }

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    # resource_access {
    #   id   = azuread_service_principal.msgraph.app_role_ids["Directory.Read.All"]
    #   type = "Role"
    # }
    resource_access {
      id   = azuread_service_principal.msgraph.oauth2_permission_scope_ids["Directory.Read.All"]
      type = "Scope"
    }
  }

  tags = [
    "azad-kube-proxy",
    "cluster_name:${var.azad_kube_proxy_config.cluster_name_prefix}-${var.environment}",
    "proxy_url:${local.azad_kube_proxy_url}",
  ]
}

resource "azuread_application_password" "azad_kube_proxy" {
  application_object_id = azuread_application.azad_kube_proxy.object_id
}

resource "azuread_application_pre_authorized" "azad_kube_proxy_azure_cli" {
  application_object_id = azuread_application.azad_kube_proxy.object_id
  authorized_app_id     = data.azuread_application_published_app_ids.well_known.result.MicrosoftAzureCli
  permission_ids        = [random_uuid.azad_kube_proxy_oauth2_permission_scope_user_impersonation.result]
}

# resource "azuread_service_principal" "azad_kube_proxy" {
#   application_id = azuread_application.azad_kube_proxy.application_id
# }

# resource "azuread_service_principal_delegated_permission_grant" "azad_kube_proxy" {
#   service_principal_object_id          = azuread_service_principal.azad_kube_proxy.object_id
#   resource_service_principal_object_id = azuread_service_principal.msgraph.object_id
#   claim_values                         = ["openid", "Directory.Read.All"]
# }
