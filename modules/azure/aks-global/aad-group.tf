resource "azuread_group" "view" {
  for_each = { for ns in var.namespaces : ns.name => ns }
  name     = "${local.aks_group_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}${each.value.name}${local.group_name_separator}view"
}

resource "azuread_group" "edit" {
  for_each = { for ns in var.namespaces : ns.name => ns }
  name     = "${local.aks_group_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}${each.value.name}${local.group_name_separator}edit"
}

resource "azuread_group" "cluster_admin" {
  name = "${local.aks_group_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}clusteradmin"
}

resource "azuread_group" "cluster_view" {
  name = "${local.aks_group_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}clusterview"
}
