# Add data source for the Azure AD Group for resource group owner
data "azuread_group" "aadGroupRgOwner" {
  for_each = {
    for ns in var.k8sNamespaces :
    ns.name => ns
    if ns.delegateRg == true
  }
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${each.key}${local.groupNameSeparator}owner"
}

# Add data source for the Azure AD Group for resource group contributor
data "azuread_group" "aadGroupRgContributor" {
  for_each = {
    for ns in var.k8sNamespaces :
    ns.name => ns
    if ns.delegateRg == true
  }
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${each.key}${local.groupNameSeparator}contributor"
}

# Add data source for the Azure AD Group for resource group reader
data "azuread_group" "aadGroupRgReader" {
  for_each = {
    for ns in var.k8sNamespaces :
    ns.name => ns
    if ns.delegateRg == true
  }
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${each.key}${local.groupNameSeparator}reader"
}

resource "azuread_group_member" "aadGroupMemberRgOwner" {
  for_each = {
    for ns in var.k8sNamespaces :
    ns.name => ns
    if ns.delegateRg == true
  }
  group_object_id  = azuread_group.aadGroupEdit[each.key].id
  member_object_id = data.azuread_group.aadGroupRgOwner[each.key].id
}

resource "azuread_group_member" "aadGroupMemberRgContributor" {
  for_each = {
    for ns in var.k8sNamespaces :
    ns.name => ns
    if ns.delegateRg == true
  }
  group_object_id  = azuread_group.aadGroupEdit[each.key].id
  member_object_id = data.azuread_group.aadGroupRgContributor[each.key].id
}

resource "azuread_group_member" "aadGroupMemberRgReader" {
  for_each = {
    for ns in var.k8sNamespaces :
    ns.name => ns
    if ns.delegateRg == true
  }
  group_object_id  = azuread_group.aadGroupView[each.key].id
  member_object_id = data.azuread_group.aadGroupRgReader[each.key].id
}
