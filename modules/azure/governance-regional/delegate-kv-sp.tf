data "azuread_application" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  display_name = "${var.service_principal_name_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.key}${var.group_name_separator}kvreader"
}

data "azuread_service_principal" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  application_id = data.azuread_application.delegate_kv_aad[each.key].application_id
}

resource "random_password" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = data.azuread_service_principal.delegate_kv_aad[each.key].id
  }
}

resource "azuread_application_password" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  application_object_id = data.azuread_application.delegate_kv_aad[each.key].id
  value                 = random_password.delegate_kv_aad[each.key].result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "azurerm_key_vault_secret" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  name = replace(data.azuread_service_principal.delegate_kv_aad[each.value.common_name].display_name, ".", "-")
  value = jsonencode({
    tenantId       = data.azurerm_subscription.current.tenant_id
    subscriptionId = data.azurerm_subscription.current.subscription_id
    clientId       = data.azuread_service_principal.delegate_kv_aad[each.value.common_name].application_id
    clientSecret   = random_password.delegate_kv_aad[each.value.common_name].result
    keyVaultName   = azurerm_key_vault.delegate_kv[each.key].name
  })
  key_vault_id = azurerm_key_vault.delegate_kv[each.key].id

  depends_on = [
    azurerm_key_vault_access_policy.ap_owner_spn,
    azurerm_key_vault_access_policy.ap_rg_aad_group,
    azurerm_key_vault_access_policy.ap_rg_sp,
    azurerm_key_vault_access_policy.ap_kvreader_sp,
    azurerm_key_vault_access_policy.ap_sub_aad_group_owner,
    azurerm_key_vault_access_policy.ap_sub_aad_group_contributor,
  ]
}
