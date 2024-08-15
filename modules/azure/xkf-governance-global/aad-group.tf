resource "azuread_group" "view" {
  for_each     = { for ns in var.namespaces : ns.name => ns }
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.name}${var.group_name_separator}view"
  #description             = "Members of this group will have view access to the ${each.value.name} namespace."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_group" "edit" {
  for_each     = { for ns in var.namespaces : ns.name => ns }
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.name}${var.group_name_separator}edit"
  #description             = "Members of this group will have edit access to the ${each.value.name} namespace."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_group" "cluster_admin" {
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}clusteradmin"
  #description             = "Members of this group will have cluster admin access to the cluster."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_group" "cluster_view" {
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}clusterview"
  #description             = "Members of this group will have cluster viewer access to the cluster."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_group" "aks_managed_identity" {
  for_each = {
    for s in ["aks"] :
    s => s
  }

  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}aksmsi"
  #description             = "The AKS cluster Managed Identity (MSI) will be members of this group to get access to different resources."
  prevent_duplicate_names = true
  security_enabled        = true
}
