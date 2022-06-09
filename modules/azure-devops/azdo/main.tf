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

data "azurerm_subscription" "this" {}

data "azurerm_key_vault" "core" {
  name                = join("-", compact(["kv-${var.environment}-${var.location_short}-${var.core_name}", var.unique_suffix]))
  resource_group_name = "rg-${var.environment}-${var.location_short}-${var.core_name}"
}

data "azurerm_key_vault_secret" "azdo_pat" {
  key_vault_id = data.azurerm_key_vault.core.id
  name         = var.azdo_pat_name
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/${var.azuredevops_organization}"
  personal_access_token = data.azurerm_key_vault_secret.azdo_pat.value
}

data "azuredevops_project" "this" {
  name = var.azuredevops_project
}

data "azuread_application" "this" {
  display_name = var.display_name
}

resource "azuread_application_password" "this" {
  application_object_id = data.azuread_application.this.object_id
  end_date_relative     = "8760h"
}

data "azuread_service_principal" "this" {
  application_id = data.azuread_application.this.application_id
}

resource "azuredevops_serviceendpoint_azurerm" "serviceendpoint" {
  project_id            = data.azuredevops_project.this.id
  service_endpoint_name = "terraform-${var.environment}"
  description           = "Terraform CI for xkf-${var.environment}"

  credentials {
    serviceprincipalid  = data.azuread_service_principal.this.id
    serviceprincipalkey = azuread_application_password.this.value
  }
  azurerm_spn_tenantid      = data.azurerm_subscription.this.tenant_id
  azurerm_subscription_id   = data.azurerm_subscription.this.id
  azurerm_subscription_name = data.azurerm_subscription.this.display_name
}
