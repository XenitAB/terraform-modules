resource "azurecaf_name" "azuread_application_delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  name          = each.key
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = local.resource_names.azuread_application_rg.prefixes
  suffixes      = concat(local.resource_names.azuread_application_rg.suffixes, ["kvreader"])
  use_slug      = false
}

resource "azuread_application" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  display_name = azurecaf_name.azuread_application_delegate_kv_aad[each.key].result
}

resource "azuread_service_principal" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  application_id = azuread_application.delegate_kv_aad[each.key].application_id
}
