resource "azuread_group" "view" {
  for_each                = { for ns in var.namespaces : ns.name => ns }
  name                    = "${local.aks_group_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}${each.value.name}${local.group_name_separator}view"
  description             = "Members of this group will have view access to the ${each.value.name} namespace."
  prevent_duplicate_names = true
}

resource "azuread_group" "edit" {
  for_each                = { for ns in var.namespaces : ns.name => ns }
  name                    = "${local.aks_group_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}${each.value.name}${local.group_name_separator}edit"
  description             = "Members of this group will have edit access to the ${each.value.name} namespace."
  prevent_duplicate_names = true
}

resource "azuread_group" "cluster_admin" {
  name                    = "${local.aks_group_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}clusteradmin"
  description             = "Members of this group will have cluster admin access to the cluster."
  prevent_duplicate_names = true
}

resource "azuread_group" "cluster_view" {
  name                    = "${local.aks_group_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}clusterview"
  description             = "Members of this group will have cluster viewer access to the cluster."
  prevent_duplicate_names = true
}

resource "azuread_group" "aks_managed_identity" {
  name                    = "${local.aks_group_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}aksmsi"
  description             = "The AKS cluster Managed Identity (MSI) will be members of this group to get access to different resources."
  prevent_duplicate_names = true
}
