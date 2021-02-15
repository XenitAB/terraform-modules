# Example: az-sub-<subName>-all-owner
data "azuread_group" "all_owner" {
  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}all${var.group_name_separator}owner"
}

resource "azuread_group_member" "sub_all_owner" {
  group_object_id  = azuread_group.sub_owner.object_id
  member_object_id = data.azuread_group.all_owner.object_id
}

# Example: az-sub-<subName>-all-contributor
data "azuread_group" "all_contributor" {
  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}all${var.group_name_separator}contributor"
}

resource "azuread_group_member" "sub_all_contributor" {
  group_object_id  = azuread_group.sub_contributor.object_id
  member_object_id = data.azuread_group.all_contributor.object_id
}

# Example: az-sub-<subName>-all-reader
data "azuread_group" "all_reader" {
  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}all${var.group_name_separator}reader"
}

resource "azuread_group_member" "sub_all_reader" {
  group_object_id  = azuread_group.sub_reader.object_id
  member_object_id = data.azuread_group.all_reader.object_id
}
