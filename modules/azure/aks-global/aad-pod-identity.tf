resource "azurerm_user_assigned_identity" "userAssignedIdentityNs" {
  for_each = {
    for ns in var.k8sNamespaces :
    ns.name => ns
  }
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  name = "uai-${var.environmentShort}-${var.locationShort}-${var.aksCommonName}-${each.key}"
}

resource "azurerm_role_assignment" "roleAssignmentUserAssignedIdentityNs" {
  for_each = {
    for ns in var.k8sNamespaces :
    ns.name => ns
  }
  scope                = azurerm_user_assigned_identity.userAssignedIdentityNs[each.key].id
  role_definition_name = "Managed Identity Operator"
  principal_id         = local.aksAadApps.aksClientAppPrincipalId
}

resource "azuread_group_member" "aadGroupMemberUai" {
  for_each = {
    for ns in var.k8sNamespaces :
    ns.name => ns
    if ns.delegateRg == true
  }
  group_object_id  = data.azuread_group.aadGroupRgContributor[each.key].id
  member_object_id = azurerm_user_assigned_identity.userAssignedIdentityNs[each.key].principal_id
}
