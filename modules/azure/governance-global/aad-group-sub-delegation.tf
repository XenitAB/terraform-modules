# Example: az-sub-<subName>-all-owner
data "azurecaf_name" "azuread_group_all_owner" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  name          = "all"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.names.this.azuread_group_all_subs.prefixes
  suffixes      = concat(module.names.this.azuread_group_all_subs.suffixes, ["owner"])
  use_slug      = false
}

resource "azuread_group" "all_owner" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  display_name  = data.azurecaf_name.azuread_group_all_owner["delegate_sub_groups"].result
  mail_nickname = "az-sub-${var.subscription_name}-all-owner"
  mail_enabled  = true
  types         = ["DynamicMembership"]
}

resource "azuread_group_member" "sub_all_owner" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  group_object_id  = azuread_group.sub_owner.object_id
  member_object_id = azuread_group.all_owner["delegate_sub_groups"].object_id
}

# Example: az-sub-<subName>-all-contributor
data "azurecaf_name" "azuread_group_all_contributor" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  name          = "all"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.names.this.azuread_group_all_subs.prefixes
  suffixes      = concat(module.names.this.azuread_group_all_subs.suffixes, ["contributor"])
  use_slug      = false
}

resource "azuread_group" "all_contributor" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  display_name  = data.azurecaf_name.azuread_group_all_contributor["delegate_sub_groups"].result
  mail_nickname = "az-sub-${var.subscription_name}-all-contributor"
  mail_enabled  = true
  types         = ["DynamicMembership"]
}

resource "azuread_group_member" "sub_all_contributor" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  group_object_id  = azuread_group.sub_contributor.object_id
  member_object_id = azuread_group.all_contributor["delegate_sub_groups"].object_id
}

# Example: az-sub-<subName>-all-reader
data "azurecaf_name" "azuread_group_all_reader" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  name          = "all"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.names.this.azuread_group_all_subs.prefixes
  suffixes      = concat(module.names.this.azuread_group_all_subs.suffixes, ["reader"])
  use_slug      = false
}

resource "azuread_group" "all_reader" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  display_name  = data.azurecaf_name.azuread_group_all_reader["delegate_sub_groups"].result
  mail_nickname = "az-sub-${var.subscription_name}-all-reader"
  mail_enabled  = true
  types         = ["DynamicMembership"]
}

resource "azuread_group_member" "sub_all_reader" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }

  group_object_id  = azuread_group.sub_reader.object_id
  member_object_id = azuread_group.all_reader["delegate_sub_groups"].object_id
}

data "azuread_service_principal" "sp_all_owner" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }
  display_name = var.service_principal_all_owner_name
}

resource "azuread_group_member" "sp_all_owner" {
  for_each = {
    for s in ["delegate_sub_groups"] :
    s => s
    if var.delegate_sub_groups
  }
  group_object_id  = azuread_group.sub_owner.id
  member_object_id = data.azuread_service_principal.sp_all_owner["delegate_sub_groups"].object_id
}
