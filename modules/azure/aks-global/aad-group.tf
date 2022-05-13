resource "azuread_group" "view" {
  for_each     = { for ns in var.namespaces : ns.name => ns }
  display_name = "${var.aks_group_name_prefix}-${var.subscription_name}-${var.environment}-${each.value.name}-view"
  #description             = "Members of this group will have view access to the ${each.value.name} namespace."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_group" "edit" {
  for_each     = { for ns in var.namespaces : ns.name => ns }
  display_name = "${var.aks_group_name_prefix}-${var.subscription_name}-${var.environment}-${each.value.name}-edit"
  #description             = "Members of this group will have edit access to the ${each.value.name} namespace."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_group" "cluster_admin" {
  display_name = "${var.aks_group_name_prefix}-${var.subscription_name}-${var.environment}-clusteradmin"
  #description             = "Members of this group will have cluster admin access to the cluster."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_group" "cluster_view" {
  display_name = "${var.aks_group_name_prefix}-${var.subscription_name}-${var.environment}-clusterview"
  #description             = "Members of this group will have cluster viewer access to the cluster."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_group" "aks_managed_identity" {
  display_name = "${var.aks_group_name_prefix}-${var.subscription_name}-${var.environment}-aksmsi"
  #description             = "The AKS cluster Managed Identity (MSI) will be members of this group to get access to different resources."
  prevent_duplicate_names = true
  security_enabled        = true
}
