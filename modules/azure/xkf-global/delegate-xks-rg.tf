# Add data source for the Azure AD Group for resource group owner
data "azuread_group" "resource_group_owner" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.key}${var.group_name_separator}owner"
}

# Add data source for the Azure AD Group for resource group contributor
data "azuread_group" "resource_group_contributor" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.key}${var.group_name_separator}contributor"
}

# Add data source for the Azure AD Group for resource group reader
data "azuread_group" "resource_group_reader" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.key}${var.group_name_separator}reader"
}

resource "azuread_group_member" "resource_group_owner" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  group_object_id  = azuread_group.edit[each.key].id
  member_object_id = data.azuread_group.resource_group_owner[each.key].id
}

resource "azuread_group_member" "resource_group_contributor" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  group_object_id  = azuread_group.edit[each.key].id
  member_object_id = data.azuread_group.resource_group_contributor[each.key].id
}

resource "azuread_group_member" "resource_group_reader" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  group_object_id  = azuread_group.view[each.key].id
  member_object_id = data.azuread_group.resource_group_reader[each.key].id
}
