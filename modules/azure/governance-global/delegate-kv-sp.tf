resource "azuread_application" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  display_name = "${var.service_principal_name_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.key}${var.group_name_separator}kvreader"
}

resource "azuread_service_principal" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  application_id = azuread_application.delegate_kv_aad[each.key].application_id
}
