# Example: az-sub-<subName>-all-owner
data "azuread_group" "all_owner" {
  name = "${local.aad_group_prefix}${local.group_name_separator}sub${local.group_name_separator}${var.subscription_name}${local.group_name_separator}all${local.group_name_separator}owner"
}

resource "azuread_group_member" "sub_all_owner" {
  group_object_id  = azuread_group.sub_owner.object_id
  member_object_id = data.azuread_group.all_owner.object_id
}

# Example: az-sub-<subName>-all-contributor
data "azuread_group" "all_contributor" {
  name = "${local.aad_group_prefix}${local.group_name_separator}sub${local.group_name_separator}${var.subscription_name}${local.group_name_separator}all${local.group_name_separator}contributor"
}

resource "azuread_group_member" "sub_all_contributor" {
  group_object_id  = azuread_group.sub_contributor.object_id
  member_object_id = data.azuread_group.all_contributor.object_id
}

# Example: az-sub-<subName>-all-reader
data "azuread_group" "all_reader" {
  name = "${local.aad_group_prefix}${local.group_name_separator}sub${local.group_name_separator}${var.subscription_name}${local.group_name_separator}all${local.group_name_separator}reader"
}

resource "azuread_group_member" "sub_all_reader" {
  group_object_id  = azuread_group.sub_reader.object_id
  member_object_id = data.azuread_group.all_reader.object_id
}
