terraform {
  backend "azurerm" {}
  required_version = ">= 1.1.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.8.0"
    }
    azuread = {
      version = "2.19.1"
      source  = "hashicorp/azuread"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.2.1"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azuread_client_config" "current" {}

data "azuread_application_published_app_ids" "well_known" {}

resource "random_uuid" "oauth2_permission_scope_user_impersonation" {}

resource "azuread_service_principal" "ms_graph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing   = true
}

data "azurerm_key_vault" "core" {
  name                = join("-", compact(["kv-${var.environment}-${var.location_short}-${var.core_name}", var.unique_suffix]))
  resource_group_name = "rg-${var.environment}-${var.location_short}-${var.core_name}"
}

data "azurerm_key_vault_secret" "azdo_pat" {
  key_vault_id = data.azurerm_key_vault.core.id
  name         = var.azdo_pat_name
}

#provider "azuredevops" {
#  org_service_url       = "https://dev.azure.com/${var.azuredevops_organization}"
#  personal_access_token = data.azurerm_key_vault_secret.azdo_pat.value
#}

#data "azuredevops_project" "this" {
#  name = var.azuredevops_project
#}

resource "azuread_application" "this" {
  display_name = "sp-sub-unbox-${var.subscription_name}-${var.environment}-owner"

  api {
    requested_access_token_version = 1
  }

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = azuread_service_principal.ms_graph.app_role_ids["Group.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = azuread_service_principal.ms_graph.app_role_ids["Application.ReadWrite.All"]
      type = "Role"
    }
  }

  tags = [
    "terraform-ci",
  ]
}

resource "azuread_application_pre_authorized" "azure_cli" {
  application_object_id = azuread_application.this.object_id
  authorized_app_id     = data.azuread_application_published_app_ids.well_known.result.MicrosoftAzureCli
  permission_ids        = [random_uuid.oauth2_permission_scope_user_impersonation.result]
}

resource "azuread_application_password" "this" {
  application_object_id = azuread_application.this.object_id
  end_date_relative     = "8760h"
}

resource "azuread_service_principal" "this" {
  application_id = azuread_application.this.application_id
}

resource "azuread_app_role_assignment" "ms_graph_group_read_write_all" {
  app_role_id         = azuread_service_principal.ms_graph.app_role_ids["Group.ReadWrite.All"]
  principal_object_id = azuread_service_principal.this.object_id
  resource_object_id  = azuread_service_principal.ms_graph.object_id
}

resource "azuread_app_role_assignment" "ms_graph_application_read_write_all" {
  app_role_id         = azuread_service_principal.ms_graph.app_role_ids["Application.ReadWrite.All"]
  principal_object_id = azuread_service_principal.this.object_id
  resource_object_id  = azuread_service_principal.ms_graph.object_id
}
