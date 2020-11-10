resource "azuread_group" "service_endpoint_join" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}${var.environment}${local.groupNameSeparator}serviceEndpointJoin"
}

resource "azuread_group_member" "service_endpoint_join_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_service_endpoint == true
  }
  group_object_id  = azuread_group.service_endpoint_join.id
  member_object_id = azuread_service_principal.aadSp[each.key].object_id
}

resource "azuread_group_member" "service_endpoint_join_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_service_endpoint == true
  }
  group_object_id  = azuread_group.service_endpoint_join.id
  member_object_id = azuread_group.rg_owner[each.key].id
}

resource "azuread_group_member" "service_endpoint_join_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_service_endpoint == true
  }
  group_object_id  = azuread_group.service_endpoint_join.id
  member_object_id = azuread_group.rg_contributor[each.key].id
}
