resource "azurerm_dns_zone" "this" {
  for_each = {
    for dns in var.dns_zone :
    dns => dns
  }
  name                = each.key
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_user_assigned_identity" "external_dns" {
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  name                = "uai-${var.environment}-${var.location_short}-${var.name}-externaldns"
}

resource "azurerm_role_assignment" "external_dns_msi" {
  scope                = azurerm_user_assigned_identity.external_dns.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_managed_identity
}

resource "azurerm_role_assignment" "external_dns_contributor" {
  for_each = {
    for dns in var.dns_zone :
    dns => dns
  }
  scope                = azurerm_dns_zone.this[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.external_dns.principal_id
}

resource "azurerm_role_assignment" "external_dns_rg_read" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.external_dns.principal_id
}
