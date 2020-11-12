resource "azurerm_dns_zone" "externalDns" {
  name                = var.dnsZone
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azuread_application" "aadAppDns" {
  name = "${local.spNamePrefix}${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${var.aksCommonName}${local.groupNameSeparator}dns"
}

resource "azuread_service_principal" "aadAppDns" {
  application_id = azuread_application.aadAppDns.application_id
}

resource "azuread_application_password" "aadAppDns" {
  application_object_id = azuread_application.aadAppDns.id
  value                 = random_password.aadAppDns.result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "random_password" "aadAppDns" {
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = azuread_service_principal.aadAppDns.id
  }
}

resource "azurerm_key_vault_secret" "kvSecretDns" {
  name = "dns-secret"
  value = base64encode(jsonencode({
    tenantId        = data.azurerm_subscription.current.tenant_id
    subscriptionId  = data.azurerm_subscription.current.subscription_id
    resourceGroup   = data.azurerm_resource_group.rg.name
    aadClientId     = azuread_service_principal.aadAppDns.application_id
    aadClientSecret = random_password.aadAppDns.result
  }))
  key_vault_id = data.azurerm_key_vault.coreKv.id
}

resource "azurerm_role_assignment" "dnsAssignment" {
  scope                = azurerm_dns_zone.externalDns.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aadAppDns.object_id
}
