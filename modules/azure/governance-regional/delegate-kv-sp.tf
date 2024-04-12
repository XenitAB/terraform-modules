resource "azuread_application_password" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  application_id = var.azuread_apps.delegate_kv[each.key].application_object_id
  end_date       = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "delegate_kv_aad" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_key_vault == true
  }

  name = replace(var.azuread_apps.delegate_kv[each.key].display_name, ".", "-")
  value = jsonencode({
    tenantId       = data.azurerm_subscription.current.tenant_id
    subscriptionId = data.azurerm_subscription.current.subscription_id
    clientId       = var.azuread_apps.delegate_kv[each.key].client_id
    clientSecret   = azuread_application_password.delegate_kv_aad[each.value.common_name].value
    keyVaultName   = azurerm_key_vault.delegate_kv[each.key].name
  })
  key_vault_id = azurerm_key_vault.delegate_kv[each.key].id
  content_type = "application/json"

  depends_on = [
    azurerm_key_vault_access_policy.ap_kvreader_sp,
    azurerm_key_vault_access_policy.ap_owner_spn
  ]
}
