# Example: az-sub-<subName>-all-owner
resource "azurecaf_name" "azuread_group_all_owner" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  name          = "all"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = local.resource_names.azuread_group_all_subs.prefixes
  suffixes      = concat(local.resource_names.azuread_group_all_subs.suffixes, ["owner"])
  use_slug      = false
}

data "azuread_group" "all_owner" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  display_name = azurecaf_name.azuread_group_all_owner["delegate_sub_groups"].result
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
resource "azurecaf_name" "azuread_group_all_contributor" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  name          = "all"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = local.resource_names.azuread_group_all_subs.prefixes
  suffixes      = concat(local.resource_names.azuread_group_all_subs.suffixes, ["contributor"])
  use_slug      = false
}

data "azuread_group" "all_contributor" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  display_name = azurecaf_name.azuread_group_all_contributor["delegate_sub_groups"].result
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
resource "azurecaf_name" "azuread_group_all_reader" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  name          = "all"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = local.resource_names.azuread_group_all_subs.prefixes
  suffixes      = concat(local.resource_names.azuread_group_all_subs.suffixes, ["reader"])
  use_slug      = false
}

data "azuread_group" "all_reader" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  display_name = azurecaf_name.azuread_group_all_reader["delegate_sub_groups"].result
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
