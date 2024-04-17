data "azurecaf_name" "azuread_application_delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  name          = each.key
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.names.this.azuread_application_rg.prefixes
  suffixes      = concat(module.names.this.azuread_application_rg.suffixes, ["kvreader"])
  use_slug      = false
}

resource "azuread_application" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  display_name = data.azurecaf_name.azuread_application_delegate_kv_aad[each.key].result
}

resource "azuread_service_principal" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  client_id = azuread_application.delegate_kv_aad[each.key].client_id
}
