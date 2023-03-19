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
