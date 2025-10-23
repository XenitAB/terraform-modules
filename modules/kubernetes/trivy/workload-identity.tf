resource "azurerm_user_assigned_identity" "trivy" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-trivy-wi"
}

resource "azurerm_federated_identity_credential" "trivy" {
  name                = azurerm_user_assigned_identity.trivy.name
  resource_group_name = azurerm_user_assigned_identity.trivy.resource_group_name
  parent_id           = azurerm_user_assigned_identity.trivy.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:trivy:trivy"
}

resource "azurerm_federated_identity_credential" "trivy_operator" {
  name                = "trivy-operator"
  resource_group_name = azurerm_user_assigned_identity.trivy.resource_group_name
  parent_id           = azurerm_user_assigned_identity.trivy.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:trivy:trivy-operator"
}

resource "azurerm_role_assignment" "trivy_acr" {
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

resource "azurerm_role_assignment" "trivy_managed" {
  scope                = azurerm_user_assigned_identity.trivy.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_managed_identity
}