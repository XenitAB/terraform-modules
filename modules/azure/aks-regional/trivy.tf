data "azurerm_container_registry" "acr" {
  name                = "acr${var.environment}${var.global_location_short}${var.name}${var.unique_suffix}"
  resource_group_name = data.azurerm_resource_group.global.name
}

resource "azurerm_user_assigned_identity" "trivy" {
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  name                = "uai-${var.environment}-${var.location_short}-${var.name}-trivy"
}

resource "azurerm_role_assignment" "trivy_managed" {
  scope                = azurerm_user_assigned_identity.trivy.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_managed_identity
}

resource "azurerm_role_assignment" "trivy_acr" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.trivy.principal_id
}
