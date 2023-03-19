/**
  * # Azure naming conventions
  *
  * This module is created to be used together with the [`aztfmod/azurecaf`](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs) provider.
  * 
  * Load the module:
  *
  * ```terraform
  * module "names" {
  *   source = "../names"
  * 
  *   resource_name_overrides = var.resource_name_overrides
  *   environment             = var.environment
  *   location_short          = var.location_short
  *   unique_suffix           = var.unique_suffix
  * }
  * ```
  *
  * Then it can be used like this:
  *
  * ```terraform
  * data "azurecaf_name" "azurerm_resource_group_rg" {
  *   for_each = {
  *     for rg in var.resource_group_configs :
  *     rg.common_name => rg
  *   }
  * 
  *   name          = each.value.common_name
  *   resource_type = "azurerm_resource_group"
  *   prefixes      = module.names.this.azurerm_resource_group.prefixes
  *   suffixes      = module.names.this.azurerm_resource_group.suffixes
  *   use_slug      = false
  * }
  * ```
  * 
  * Then you use it with a resource:
  *
  * ```terraform
  * resource "azurerm_resource_group" "rg" {
  *   for_each = {
  *     for rg in var.resource_group_configs :
  *     rg.common_name => rg
  *   }
  * 
  *   name     = data.azurecaf_name.azurerm_resource_group_rg[each.key].result
  *   location = var.location
  *   tags = merge(
  *     {
  *       "Environment"   = var.environment,
  *       "LocationShort" = var.location_short
  *     },
  *     each.value.tags
  *   )
  * }
  * ```
  *
  */

terraform {
  required_version = ">= 1.3.0"
}

locals {
  resource_names = {
    azuread_group_rg = {
      prefixes = try(var.resource_name_overrides.azuread_group_rg.prefixes, null) != null ? var.resource_name_overrides.azuread_group_rg.prefixes : [var.azure_ad_group_prefix, "rg", var.subscription_name, var.environment]
      suffixes = try(var.resource_name_overrides.azuread_group_rg.suffixes, null) != null ? var.resource_name_overrides.azuread_group_rg.suffixes : []
    }
    azuread_group_sub = {
      prefixes = try(var.resource_name_overrides.azuread_group_sub.prefixes, null) != null ? var.resource_name_overrides.azuread_group_sub.prefixes : [var.azure_ad_group_prefix, "sub", var.subscription_name, var.environment]
      suffixes = try(var.resource_name_overrides.azuread_group_sub.suffixes, null) != null ? var.resource_name_overrides.azuread_group_sub.suffixes : []
    }
    azuread_group_all_subs = {
      prefixes = try(var.resource_name_overrides.azuread_group_all_subs.prefixes, null) != null ? var.resource_name_overrides.azuread_group_all_subs.prefixes : [var.azure_ad_group_prefix, "sub", var.subscription_name]
      suffixes = try(var.resource_name_overrides.azuread_group_all_subs.suffixes, null) != null ? var.resource_name_overrides.azuread_group_all_subs.suffixes : []
    }
    azuread_group_acr = {
      prefixes = try(var.resource_name_overrides.azuread_group_acr.prefixes, null) != null ? var.resource_name_overrides.azuread_group_acr.prefixes : [var.aks_group_name_prefix, var.subscription_name, var.environment]
      suffixes = try(var.resource_name_overrides.azuread_group_acr.suffixes, null) != null ? var.resource_name_overrides.azuread_group_acr.suffixes : []
    }
    azuread_application_rg = {
      prefixes = try(var.resource_name_overrides.azuread_application_rg.prefixes, null) != null ? var.resource_name_overrides.azuread_application_rg.prefixes : [var.service_principal_name_prefix, "rg", var.subscription_name, var.environment]
      suffixes = try(var.resource_name_overrides.azuread_application_rg.suffixes, null) != null ? var.resource_name_overrides.azuread_application_rg.suffixes : []
    }
    azuread_application_sub = {
      prefixes = try(var.resource_name_overrides.azuread_application_sub.prefixes, null) != null ? var.resource_name_overrides.azuread_application_sub.prefixes : [var.service_principal_name_prefix, "sub", var.subscription_name, var.environment]
      suffixes = try(var.resource_name_overrides.azuread_application_sub.suffixes, null) != null ? var.resource_name_overrides.azuread_application_sub.suffixes : []
    }
    azurerm_resource_group = {
      prefixes = try(var.resource_name_overrides.azurerm_resource_group.prefixes, null) != null ? var.resource_name_overrides.azurerm_resource_group.prefixes : ["rg", var.environment, var.location_short]
      suffixes = try(var.resource_name_overrides.azurerm_resource_group.suffixes, null) != null ? var.resource_name_overrides.azurerm_resource_group.suffixes : []
    }
    azurerm_key_vault = {
      prefixes = try(var.resource_name_overrides.azurerm_key_vault.prefixes, null) != null ? var.resource_name_overrides.azurerm_key_vault.prefixes : ["kv", var.environment, var.location_short]
      suffixes = try(var.resource_name_overrides.azurerm_key_vault.suffixes, null) != null ? var.resource_name_overrides.azurerm_key_vault.suffixes : [var.unique_suffix]
    }
  }
}
