resource "azurerm_user_assigned_identity" "grafana_agent" {
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  name                = "uai-${var.environment}-${var.location_short}-${var.name}-grafanaagent"
}

resource "azurerm_role_assignment" "grafana_agent_msi" {
  scope                = azurerm_user_assigned_identity.grafana_agent.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azuread_group.aks_managed_identity.id
}

resource "azurerm_role_assignment" "grafana_agent_contributor" {
  scope                = azurerm_dns_zone.this.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.grafana_agent.principal_id
}

resource "azurerm_role_assignment" "grafana_agent_rg_read" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.grafana_agent.principal_id
}
