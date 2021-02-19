data "azuread_group" "acr_push" {
  display_name = "${var.aks_group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}acrpush"
}

resource "azuread_group_member" "acr_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true
  }
  group_object_id  = data.azuread_group.acr_push.id
  member_object_id = data.azuread_service_principal.aad_sp[each.key].object_id
}

