terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azuread = {
      version = "2.50.0"
      source  = "hashicorp/azuread"
    }
    azurerm = {
      version = "4.7.0"
      source  = "hashicorp/azurerm"
    }
  }
}

data "azuread_group" "view" {
  for_each     = { for ns in var.namespaces : ns.name => ns }
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.name}${var.group_name_separator}view"
}

data "azuread_group" "edit" {
  for_each     = { for ns in var.namespaces : ns.name => ns }
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.name}${var.group_name_separator}edit"
}

data "azuread_group" "cluster_admin" {
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}clusteradmin"
}

data "azuread_group" "cluster_view" {
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}clusterview"
}

data "azuread_group" "aks_managed_identity" {
  for_each = {
    for s in ["aks"] :
    s => s
  }

  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}aksmsi"
}
