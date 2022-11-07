# Example: az-sub-<subName>-all-owner
data "azuread_group" "all_owner" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}all${var.group_name_separator}owner"
}

resource "azuread_group_member" "sub_all_owner" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  group_object_id  = azuread_group.sub_owner.object_id
  member_object_id = data.azuread_group.all_owner["delegate_sub_groups"].object_id
}

# Example: az-sub-<subName>-all-contributor
data "azuread_group" "all_contributor" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}all${var.group_name_separator}contributor"
}

resource "azuread_group_member" "sub_all_contributor" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  group_object_id  = azuread_group.sub_contributor.object_id
  member_object_id = data.azuread_group.all_contributor["delegate_sub_groups"].object_id
}

# Example: az-sub-<subName>-all-reader
data "azuread_group" "all_reader" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}all${var.group_name_separator}reader"
}

resource "azuread_group_member" "sub_all_reader" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  group_object_id  = azuread_group.sub_reader.object_id
  member_object_id = data.azuread_group.all_reader["delegate_sub_groups"].object_id
}

data "azuread_group" "admin_group" {
  display_name = var.admin_group
}

resource "azuread_group_member" "admin_group" {
  # Add if statment
  group_object_id  = azuread_group.sub_owner.object_id
  member_object_id = data.azuread_group.admin_group.object_id
}
