data "azurerm_resource_group" "global" {
  name = "rg-${var.environment}-${var.location_short}-global"
}

data "azurerm_dns_zone" "this" {
  for_each = {
    for dns in var.dns_zones :
    dns => dns
  }
  name                = each.key
  resource_group_name = data.azurerm_resource_group.global.name
}

resource "azurerm_user_assigned_identity" "prometheus" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-prometheus-wi"
}

resource "azurerm_role_assignment" "prometheus_contributor" {
  for_each = {
    for dns in var.dns_zones :
    dns => dns
  }
  scope                = data.azurerm_dns_zone.this[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.prometheus.principal_id
}

resource "azurerm_federated_identity_credential" "control_plane_logs" {
  name                = azurerm_user_assigned_identity.prometheus.name
  resource_group_name = azurerm_user_assigned_identity.prometheus.resource_group_name
  parent_id           = azurerm_user_assigned_identity.prometheus.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:azure-metrics:prometheus"
}