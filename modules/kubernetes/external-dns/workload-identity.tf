data "azurerm_resource_group" "global" {
  name = "rg-${var.environment}-${var.location_short}-global"
}

resource "azurerm_user_assigned_identity" "external_dns" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-external-dns-wi"
}

resource "azurerm_role_assignment" "external_dns_contributor" {
  for_each = {
    for dns in var.dns_zones :
    dns => dns
    if var.rbac_create
  }
  scope                = each.key
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.external_dns.principal_id
}

resource "azurerm_role_assignment" "external_dns_reader" {
  scope                = data.azurerm_resource_group.global.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.external_dns.principal_id
}

resource "azurerm_federated_identity_credential" "external_dns" {
  name                = azurerm_user_assigned_identity.external_dns.name
  resource_group_name = azurerm_user_assigned_identity.external_dns.resource_group_name
  parent_id           = azurerm_user_assigned_identity.external_dns.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:external-dns:external-dns"
}