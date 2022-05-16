resource "azuread_group" "service_endpoint_join" {
  display_name            = "${var.azure_ad_group_prefix}-sub-${var.subscription_name}-${var.environment}-${location_short}-serviceEndpointJoin"
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azuread_group_member" "service_endpoint_join_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_endpoint == true
  }
  group_object_id  = azuread_group.service_endpoint_join.id
  member_object_id = var.service_principal_object_id[each.key]
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
