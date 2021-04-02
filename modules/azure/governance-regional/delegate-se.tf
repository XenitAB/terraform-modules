resource "azuread_group_member" "service_endpoint_join_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_endpoint == true
  }
  group_object_id  = var.azuread_groups.service_endpoint_join.id
  member_object_id = var.azuread_apps.rg_contributor[each.key].service_principal_object_id
}

resource "azuread_group_member" "service_endpoint_join_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_endpoint == true
  }
  group_object_id  = var.azuread_groups.service_endpoint_join.id
  member_object_id = var.azuread_groups.rg_owner[each.key].id
}

resource "azuread_group_member" "service_endpoint_join_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_endpoint == true
  }
  group_object_id  = var.azuread_groups.service_endpoint_join.id
  member_object_id = var.azuread_groups.rg_contributor[each.key].id
}
