resource "azurerm_container_registry" "acr" {
  name                = var.acr_name_override == "" ? "acr${var.environment}${var.location_short}${var.name}${var.unique_suffix}" : var.acr_name_override
  resource_group_name = resource.azurerm_resource_group.this.name
  location            = resource.azurerm_resource_group.this.location
  sku                 = "Standard"
  admin_enabled       = var.acr_admin_enabled
}

resource "azurerm_container_registry_task" "acr_purge_task" {
  name                  = "acr-purge-ask"
  container_registry_id = azurerm_container_registry.acr.id

  platform {
    os           = "Linux"
    architecture = "amd64"
  }

  encoded_step {
    task_content = <<EOF
version: v1.1.0
steps: 
  - cmd: acr purge --filter '.*:.*' --ago 365d --keep 5
    disableWorkingDirectoryOverride: true
    timeout: 3600
EOF
  }

  timer_trigger {
    name     = "every-monday"
    schedule = "0 12 * * 1"
    enabled  = true
  }
}

# Add AcrPull permission for the AKS Service Principal (Client)
# This makes it possible for the AKS cluster to pull images without additional authentication

# More info about Azure Container Registry Roles can be found here: https://docs.microsoft.com/en-us/azure/container-registry/container-registry-roles

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
