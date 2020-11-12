resource "azurerm_dns_zone" "external_dns" {
  name                = var.dns_zone
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azuread_application" "external_dns" {
  name = "${local.service_principal_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}${var.name}${local.group_name_separator}dns"
}

resource "azuread_service_principal" "external_dns" {
  application_id = azuread_application.external_dns.application_id
}

resource "azuread_application_password" "external_dns" {
  application_object_id = azuread_application.external_dns.id
  value                 = random_password.external_dns.result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "random_password" "external_dns" {
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = azuread_service_principal.external_dns.id
  }
}

resource "azurerm_key_vault_secret" "external_dns" {
  name = "external-dns"
  value = base64encode(jsonencode({
    tenant_id              = data.azurerm_subscription.current.tenant_id
    subscription_id        = data.azurerm_subscription.current.subscription_id
    resource_group_name    = data.azurerm_resource_group.rg.name
    azure_ad_client_id     = azuread_service_principal.external_dns.application_id
    azure_ad_client_secret = random_password.external_dns.result
  }))
  key_vault_id = data.azurerm_key_vault.core.id
}

resource "azurerm_role_assignment" "external_dns" {
  scope                = azurerm_dns_zone.external_dns.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.external_dns.object_id
}
