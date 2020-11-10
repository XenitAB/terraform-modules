resource "azuread_group" "acr_push" {
  name = "${local.aksGroupNamePrefix}${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}${var.environment}${local.groupNameSeparator}acrpush"
}

resource "azuread_group" "acr_pull" {
  name = "${local.aksGroupNamePrefix}${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}${var.environment}${local.groupNameSeparator}acrpull"
}

resource "azuread_group_member" "acr_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_aks == true
  }
  group_object_id  = azuread_group.acr_push.id
  member_object_id = azuread_service_principal.aadSp[each.key].object_id
}

resource "azuread_group_member" "acr_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_aks == true
  }
  group_object_id  = azuread_group.acr_push.id
  member_object_id = azuread_group.rg_owner[each.key].id
}

resource "azuread_group_member" "acr_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_aks == true
  }
  group_object_id  = azuread_group.acr_push.id
  member_object_id = azuread_group.rg_contributor[each.key].id
}

resource "azuread_group_member" "acr_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_aks == true
  }
  group_object_id  = azuread_group.acr_pull.id
  member_object_id = azuread_group.rg_reader[each.key].id
}
