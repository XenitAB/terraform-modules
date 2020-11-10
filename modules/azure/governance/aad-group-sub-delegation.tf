# Example: az-sub-<subName>-all-owner
data "azuread_group" "all_owner" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}all${local.groupNameSeparator}owner"
}

resource "azuread_group_member" "sub_all_owner" {
  group_object_id  = azuread_group.sub_owner.object_id
  member_object_id = data.azuread_group.all_owner.object_id
}

# Example: az-sub-<subName>-all-contributor
data "azuread_group" "all_contributor" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}all${local.groupNameSeparator}contributor"
}

resource "azuread_group_member" "sub_all_contributor" {
  group_object_id  = azuread_group.sub_contributor.object_id
  member_object_id = data.azuread_group.all_contributor.object_id
}

# Example: az-sub-<subName>-all-reader
data "azuread_group" "all_reader" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}all${local.groupNameSeparator}reader"
}

resource "azuread_group_member" "sub_all_reader" {
  group_object_id  = azuread_group.sub_reader.object_id
  member_object_id = data.azuread_group.all_reader.object_id
}
