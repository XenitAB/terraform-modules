/**
  * # Azure AD Application configuration for Azure AD Kubernetes API Proxy
  *
  * This module is used to configure the Azure AD Application used by [`azad-kube-proxy`](https://github.com/XenitAB/azad-kube-proxy).
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azuread = {
      version = "2.50.0"
      source  = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

data "azuread_client_config" "current" {}

data "azuread_application_published_app_ids" "well_known" {}

resource "random_uuid" "oauth2_permission_scope_user_impersonation" {}

resource "azuread_service_principal" "ms_graph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}

resource "azuread_application" "this" {
  display_name = var.display_name
  identifier_uris = [
    var.proxy_url
  ]

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access azad-kube-proxy on behalf of the signed-in user."
      admin_consent_display_name = "Access azad-kube-proxy"
      enabled                    = true
      id                         = random_uuid.oauth2_permission_scope_user_impersonation.result
      type                       = "User"
      user_consent_description   = "Allow the application to access azad-kube-proxy on your behalf."
      user_consent_display_name  = "Access azad-kube-proxy"
      value                      = "user_impersonation"
    }
  }

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = azuread_service_principal.ms_graph.app_role_ids["Directory.Read.All"]
      type = "Role"
    }
  }

  tags = [
    "azad-kube-proxy",
    "cluster_name:${var.cluster_name}",
    "proxy_url:${var.proxy_url}",
  ]
}

resource "azuread_application_pre_authorized" "azure_cli" {
  application_id       = azuread_application.this.id
  authorized_client_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftAzureCli
  permission_ids       = [random_uuid.oauth2_permission_scope_user_impersonation.result]
}

resource "azuread_application_password" "this" {
  application_id = azuread_application.this.id
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

resource "azuread_app_role_assignment" "ms_graph_directory_read_all" {
  app_role_id         = azuread_service_principal.ms_graph.app_role_ids["Directory.Read.All"]
  principal_object_id = azuread_service_principal.this.object_id
  resource_object_id  = azuread_service_principal.ms_graph.object_id
}
