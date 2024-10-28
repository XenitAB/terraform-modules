/**
  * # Core
  *
  * This module is used to create core resources like virtual network for the subscription.
  * This module assumes that you have a RG called `rg-<env>-<location_short>-log`.
  * Easiest is to define this RG in the governance module.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "3.110.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.50.0"
      source  = "hashicorp/azuread"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "2.0.0-preview3"
    }
  }
}

module "names" {
  source = "../names"

  resource_name_overrides      = var.resource_name_overrides
  subscription_name            = var.subscription_name
  environment                  = var.environment
  location_short               = var.location_short
  unique_suffix                = var.unique_suffix
  azure_ad_group_prefix        = var.azure_ad_group_prefix
  azure_role_definition_prefix = var.azure_role_definition_prefix
}
