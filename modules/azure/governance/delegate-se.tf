resource "azuread_group" "service_endpoint_join" {
  name                    = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}serviceEndpointJoin"
  prevent_duplicate_names = true
}

resource "azuread_group_member" "service_endpoint_join_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_endpoint == true
  }
  group_object_id  = azuread_group.service_endpoint_join.id
  member_object_id = azuread_service_principal.aad_sp[each.key].object_id
}

resource "azuread_group_member" "service_endpoint_join_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_endpoint == true
  }
  group_object_id  = azuread_group.service_endpoint_join.id
  member_object_id = azuread_group.rg_owner[each.key].id
}

resource "azuread_group_member" "service_endpoint_join_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_endpoint == true
  }
  group_object_id  = azuread_group.service_endpoint_join.id
  member_object_id = azuread_group.rg_contributor[each.key].id
}
