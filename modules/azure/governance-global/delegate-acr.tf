resource "azuread_group" "acr_push" {
  for_each = {
    for s in ["delegate_acr"] :
    s => s
    if var.delegate_acr
  }

  display_name            = "${var.aks_group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}acrpush"
  prevent_duplicate_names = true
}

resource "azuread_group" "acr_pull" {
  for_each = {
    for s in ["delegate_acr"] :
    s => s
    if var.delegate_acr
  }

  display_name            = "${var.aks_group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}acrpull"
  prevent_duplicate_names = true
}

resource "azuread_group_member" "acr_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_push["delegate_acr"].id
  member_object_id = azuread_service_principal.aad_sp[each.key].object_id
}

resource "azuread_group_member" "acr_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_push["delegate_acr"].id
  member_object_id = azuread_group.rg_owner[each.key].id
}

resource "azuread_group_member" "acr_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_push["delegate_acr"].id
  member_object_id = azuread_group.rg_contributor[each.key].id
}

resource "azuread_group_member" "acr_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_pull["delegate_acr"].id
  member_object_id = azuread_group.rg_reader[each.key].id
}
