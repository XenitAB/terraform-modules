resource "azurerm_dns_zone" "this" {
  name                = var.dns_zone
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_user_assigned_identity" "external_dns" {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  name                = "uai-${var.environment}-${var.location_short}-${var.name}-externaldns"
}

resource "azurerm_role_assignment" "external_dns_msi" {
  scope                = azurerm_user_assigned_identity.external_dns.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azuread_group.aks_managed_identity.id
}

resource "azurerm_role_assignment" "external_dns_contributor" {
  scope                = azurerm_dns_zone.this.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.aks_managed_identity.id
}

resource "azurerm_role_assignment" "external_dns_rg_read" {
  scope = data.azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.aks_managed_identity.id
}
