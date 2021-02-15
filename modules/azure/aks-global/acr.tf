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
  principal_id         = azuread_group.aks_managed_identity.id
}

# Add data source for the Azure AD Group for AcrPull
data "azuread_group" "acr_pull" {
  display_name = "${var.aks_group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}acrpull"
}

# Add data source for the Azure AD Group for AcrPush
data "azuread_group" "acr_push" {
  display_name = "${var.aks_group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}acrpush"
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
