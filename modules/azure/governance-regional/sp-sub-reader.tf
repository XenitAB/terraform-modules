resource "random_password" "sub_reader_sp" {
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = var.azuread_apps.sub_reader.service_principal_object_id
  }
}

resource "azuread_application_password" "sub_reader_sp" {
  application_object_id = var.azuread_apps.sub_reader.application_object_id
  value                 = random_password.sub_reader_sp.result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

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
    clientId       = var.azuread_apps.sub_reader.application_id
    clientSecret   = random_password.sub_reader_sp.result
  })
  key_vault_id = azurerm_key_vault.delegate_kv[var.core_name].id
  content_type = "application/json"

  depends_on = [
    azurerm_key_vault_access_policy.ap_owner_spn
  ]
}
