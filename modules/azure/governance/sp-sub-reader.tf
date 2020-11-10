resource "azuread_application" "aadSubReaderApp" {
  name = "${local.sp_name_prefix}${local.group_name_separator}sub${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}reader"
}

resource "azuread_service_principal" "aadSubReaderSp" {
  application_id = azuread_application.aadSubReaderApp.application_id
}

resource "azurerm_role_assignment" "roleAssignmentSubReaderSp" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.aadSubReaderSp.object_id
}

resource "random_password" "aadSubReaderSpSecret" {
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = azuread_service_principal.aadSubReaderSp.id
  }
}

resource "azuread_application_password" "aadSubReaderSpSecret" {
  application_object_id = azuread_application.aadSubReaderApp.id
  value                 = random_password.aadSubReaderSpSecret.result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "azurerm_key_vault_secret" "aadSubReaderSpKvSecret" {
  for_each = {
    for core_rg in local.core_rgs :
    core_rg => core_rg
  }

  name = replace(azuread_service_principal.aadSubReaderSp.display_name, ".", "-")
  value = jsonencode({
    tenantId       = data.azurerm_subscription.current.tenant_id
    subscriptionId = data.azurerm_subscription.current.subscription_id
    clientId       = azuread_service_principal.aadSubReaderSp.application_id
    clientSecret   = random_password.aadSubReaderSpSecret.result
  })
  key_vault_id = azurerm_key_vault.delegateKv[each.key].id

  depends_on = [
    azurerm_key_vault_access_policy.delegateKvApOwnerSpn
  ]
}
