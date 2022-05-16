resource "azurerm_user_assigned_identity" "aad_pod_identity" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  name = "uai-${var.environment}-${var.location_short}-${var.name}-${each.key}"
}

resource "azurerm_role_assignment" "aad_pod_identity" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }
  scope                = azurerm_user_assigned_identity.aad_pod_identity[each.key].id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_managed_identity_group_id.id
}

resource "azuread_group_member" "aad_pod_identity" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }
  group_object_id  = data.azuread_group.resource_group_contributor[each.key].id
  member_object_id = azurerm_user_assigned_identity.aad_pod_identity[each.key].principal_id
}
