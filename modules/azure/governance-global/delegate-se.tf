data "azurecaf_name" "azuread_group_service_endpoint_join" {
  name          = "serviceEndpointJoin"
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.naming.names.azuread_group_sub.prefixes
  suffixes      = module.naming.names.azuread_group_sub.suffixes
  use_slug      = false
}

resource "azuread_group" "service_endpoint_join" {
  display_name            = data.azurecaf_name.azuread_group_service_endpoint_join.result
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
  member_object_id = azuread_service_principal.aad_sp[each.key].id
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
