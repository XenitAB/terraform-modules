resource "azuread_application" "sub_reader_sp" {
  name = "${local.sp_name_prefix}${local.group_name_separator}sub${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}reader"
}

resource "azuread_service_principal" "sub_reader_sp" {
  application_id = azuread_application.sub_reader_sp.application_id
}

resource "azurerm_role_assignment" "sub_reader_sp" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sub_reader_sp.object_id
}

resource "random_password" "sub_reader_sp" {
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = azuread_service_principal.sub_reader_sp.id
  }
}

resource "azuread_application_password" "sub_reader_sp" {
  application_object_id = azuread_application.sub_reader_sp.id
  value                 = random_password.sub_reader_sp.result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "azurerm_key_vault_secret" "sub_reader_sp" {
  for_each = {
    for core_rg in local.core_rgs :
    core_rg => core_rg
  }

  name = replace(azuread_service_principal.sub_reader_sp.display_name, ".", "-")
  value = jsonencode({
    tenantId       = data.azurerm_subscription.current.tenant_id
    subscriptionId = data.azurerm_subscription.current.subscription_id
    clientId       = azuread_service_principal.sub_reader_sp.application_id
    clientSecret   = random_password.sub_reader_sp.result
  })
  key_vault_id = azurerm_key_vault.delegateKv[each.key].id

  depends_on = [
    azurerm_key_vault_access_policy.delegateKvApOwnerSpn
  ]
}
