# Setting the value `prevent_duplicate_names = !var.directory_reader_enabled` is a bad work around to an issue. There is a bug in The Azure AD provider which breaks AD group recreation when `prevent_duplicate_names = true`. When the change to enbaled assignable_to_role was created all groups need to be recreated. This should be removed either when the issue is resolved or when the variable is no longer needed.
# https://github.com/hashicorp/terraform-provider-azuread/issues/697

locals {
  directory_reader_id = "88d8e3e3-8f55-4a1e-953a-9b9898b8876b"
}

resource "azuread_group" "view" {
  for_each     = { for ns in var.namespaces : ns.name => ns }
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.name}${var.group_name_separator}view"
  #description             = "Members of this group will have view access to the ${each.value.name} namespace."
  #prevent_duplicate_names = !var.directory_reader_enabled
  prevent_duplicate_names = false
  security_enabled        = true
  assignable_to_role      = var.directory_reader_enabled
}

resource "azuread_directory_role_assignment" "view" {
  for_each            = { for ns in var.namespaces : ns.name => ns if var.directory_reader_enabled }
  principal_object_id = azuread_group.view[each.key].object_id
  role_id             = local.directory_reader_id
}

resource "azuread_group" "edit" {
  for_each     = { for ns in var.namespaces : ns.name => ns }
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.name}${var.group_name_separator}edit"
  #description             = "Members of this group will have edit access to the ${each.value.name} namespace."
  #prevent_duplicate_names = !var.directory_reader_enabled
  prevent_duplicate_names = false
  security_enabled        = true
  assignable_to_role      = var.directory_reader_enabled
}

resource "azuread_directory_role_assignment" "edit" {
  for_each            = { for ns in var.namespaces : ns.name => ns if var.directory_reader_enabled }
  principal_object_id = azuread_group.edit[each.key].object_id
  role_id             = local.directory_reader_id
}

resource "azuread_group" "cluster_admin" {
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}clusteradmin"
  #description             = "Members of this group will have cluster admin access to the cluster."
  #prevent_duplicate_names = !var.directory_reader_enabled
  prevent_duplicate_names = false
  security_enabled        = true
  assignable_to_role      = var.directory_reader_enabled
}

resource "azuread_directory_role_assignment" "cluster_admin" {
  for_each            = { for s in ["cluster-admin"] : s => s if var.directory_reader_enabled }
  principal_object_id = azuread_group.cluster_admin.object_id
  role_id             = local.directory_reader_id
}

resource "azuread_group" "cluster_view" {
  display_name = "${var.group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}clusterview"
  #description             = "Members of this group will have cluster viewer access to the cluster."
  #prevent_duplicate_names = !var.directory_reader_enabled
  prevent_duplicate_names = false
  security_enabled        = true
  assignable_to_role      = var.directory_reader_enabled
}

resource "azuread_directory_role_assignment" "cluster_view" {
  for_each            = { for s in ["cluster-view"] : s => s if var.directory_reader_enabled }
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
  #prevent_duplicate_names = !var.directory_reader_enabled
  prevent_duplicate_names = false
  security_enabled        = true
}
