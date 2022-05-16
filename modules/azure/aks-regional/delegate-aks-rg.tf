# Add data source for the Azure AD Group for resource group owner
data "azuread_group" "resource_group_owner" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  display_name = "${var.azure_ad_group_prefix}-${var.location_short}-${var.subscription_name}-${var.environment}-${each.key}-owner"
}

# Add data source for the Azure AD Group for resource group contributor
data "azuread_group" "resource_group_contributor" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  display_name = "${var.azure_ad_group_prefix}-${var.location_short}-${var.subscription_name}-${var.environment}-${each.key}-contributor"
}

# Add data source for the Azure AD Group for resource group reader
data "azuread_group" "resource_group_reader" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  display_name = "${var.azure_ad_group_prefix}-${var.location_short}-${var.subscription_name}-${var.environment}-${each.key}-reader"
}

resource "azuread_group_member" "resource_group_owner" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  group_object_id  = var.azuread_group.edit[each.key].id
  member_object_id = data.azuread_group.resource_group_owner[each.key].id
}

resource "azuread_group_member" "resource_group_contributor" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  group_object_id  = var.azuread_group.edit[each.key].id
  member_object_id = data.azuread_group.resource_group_contributor[each.key].id
}

resource "azuread_group_member" "resource_group_reader" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  group_object_id  = var.azuread_group.view[each.key].id
  member_object_id = data.azuread_group.resource_group_reader[each.key].id
}
