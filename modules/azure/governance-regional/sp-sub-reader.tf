resource "azuread_application_password" "sub_reader_sp" {
  application_id = var.azuread_apps.sub_reader.application_object_id
  end_date       = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "sub_reader_sp" {
  name = replace(var.azuread_apps.sub_reader.display_name, ".", "-")
  value = jsonencode({
    tenantId       = data.azurerm_subscription.current.tenant_id
    subscriptionId = data.azurerm_subscription.current.subscription_id
    clientId       = var.azuread_apps.sub_reader.client_id
    clientSecret   = azuread_application_password.sub_reader_sp.value
  })
  key_vault_id = azurerm_key_vault.delegate_kv[var.core_name].id
  content_type = "application/json"

  depends_on = [
    azurerm_role_assignment.ra_owner_spn,
    azurerm_key_vault_access_policy.ap_owner_spn
  ]
}
