# More info about Azure Container Registry Roles can be found here: https://docs.microsoft.com/en-us/azure/container-registry/container-registry-roles

# Create Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "acr${var.environment}${var.location_short}${var.name}${var.unique_suffix}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  sku                 = "Basic"
  admin_enabled       = false
}

# Add AcrPull permission for the AKS Service Principal (Client)
# This makes it possible for the AKS cluster to pull images without additional authentication

resource "azurerm_role_assignment" "aks" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_managed_identity
}

# Add data source for the Azure AD Group for AcrPull
data "azuread_group" "acr_pull" {
  display_name = "${var.aks_group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}acrpull"
}

# Add data source for the Azure AD Group for AcrPush
data "azuread_group" "acr_push" {
  display_name = "${var.aks_group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}acrpush"
}

# Add data source for the Azure AD Group for AcrReader
data "azuread_group" "acr_reader" {
  display_name = "${var.aks_group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}acrreader"
}

# Assign AcrPull permissions to the Azure AD Group for AcrPull
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = data.azuread_group.acr_pull.id
}

# Assign AcrPush permissions to the Azure AD Group for AcrPull
resource "azurerm_role_assignment" "acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = data.azuread_group.acr_push.id
}

# Assign Reader permissions to the Azure AD Group for AcrReader
resource "azurerm_role_assignment" "acr_reader" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_group.acr_reader.id
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
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.trivy.principal_id
}
