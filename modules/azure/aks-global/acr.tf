# Create Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "acr${var.environmentShort}${var.locationShort}${var.aksCommonName}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

# Add AcrPull permission for the AKS Service Principal (Client)
# This makes it possible for the AKS cluster to pull images without additional authentication
resource "azurerm_role_assignment" "roleAssignmentAcrPull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = local.aksAadApps.aksClientAppPrincipalId
}

# Add data source for the Azure AD Group for AcrPull
data "azuread_group" "aadGroupAcrPull" {
  name = "aks-${var.subscriptionCommonName}-${var.environmentShort}-acrpull"
}

# Add data source for the Azure AD Group for AcrPush
data "azuread_group" "aadGroupAcrPush" {
  name = "aks-${var.subscriptionCommonName}-${var.environmentShort}-acrpush"
}

# Assign AcrPull permissions to the Azure AD Group for AcrPull
resource "azurerm_role_assignment" "roleAssignmentAAdGroupAcrPull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = data.azuread_group.aadGroupAcrPull.id
}

# Assign AcrPush permissions to the Azure AD Group for AcrPull
resource "azurerm_role_assignment" "roleAssignmentAAdGroupAcrPush" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = data.azuread_group.aadGroupAcrPush.id
}
