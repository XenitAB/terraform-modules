locals {
  directory_reader_id = "88d8e3e3-8f55-4a1e-953a-9b9898b8876b"
}

resource "azuread_group" "view" {
  for_each     = { for ns in var.namespaces : ns.name => ns }
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.name}${var.group_name_separator}view"
  #description             = "Members of this group will have view access to the ${each.value.name} namespace."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_directory_role_assignment" "view" {
  for_each            = { for ns in var.namespaces : ns.name => ns }
  principal_object_id = azuread_group.view[each.key].object_id
  role_id             = local.directory_reader_id
}

resource "azuread_group" "edit" {
  for_each     = { for ns in var.namespaces : ns.name => ns }
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.name}${var.group_name_separator}edit"
  #description             = "Members of this group will have edit access to the ${each.value.name} namespace."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_directory_role_assignment" "edit" {
  for_each            = { for ns in var.namespaces : ns.name => ns }
  principal_object_id = azuread_group.edit[each.key].object_id
  role_id             = local.directory_reader_id
}

resource "azuread_group" "cluster_admin" {
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}clusteradmin"
  #description             = "Members of this group will have cluster admin access to the cluster."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_directory_role_assignment" "cluster_admin" {
  principal_object_id = azuread_group.cluster_admin.object_id
  role_id             = local.directory_reader_id
}

resource "azuread_group" "cluster_view" {
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}clusterview"
  #description             = "Members of this group will have cluster viewer access to the cluster."
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_directory_role_assignment" "cluster_view" {
  principal_object_id = azuread_group.cluster_view.object_id
  role_id             = local.directory_reader_id
}

resource "azuread_group" "aks_managed_identity" {
  for_each = {
    for s in ["aks"] :
    s => s
    if var.cloud_provider == "azure"
  }

  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}aksmsi"
  #description             = "The AKS cluster Managed Identity (MSI) will be members of this group to get access to different resources."
  prevent_duplicate_names = true
  security_enabled        = true
}
