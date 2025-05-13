resource "azurerm_user_assigned_identity" "flux_system" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-flux_system-wi"
}

resource "azurerm_federated_identity_credential" "flux_system" {
  name                = azurerm_user_assigned_identity.flux_system.name
  resource_group_name = azurerm_user_assigned_identity.flux_system.resource_group_name
  parent_id           = azurerm_user_assigned_identity.flux_system.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:flux_system:source-controller"
}

resource "azurerm_role_assignment" "flux_system_acr" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.trivy.principal_id
}

data "azurerm_resource_group" "global" {
  name = "rg-${var.environment}-${var.location_short}-global"
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name_override == "" ? "acr${var.environment}${var.location_short}${var.aks_name}${var.unique_suffix}" : var.acr_name_override
  resource_group_name = data.azurerm_resource_group.global.name
}

resource "azurerm_role_assignment" "flux_managed" {
  scope                = azurerm_user_assigned_identity.trivy.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_managed_identity
}
