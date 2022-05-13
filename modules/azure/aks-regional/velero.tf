#tfsec:ignore:azure-storage-queue-services-logging-enabled
resource "azurerm_storage_account" "velero" {
  name                            = "strg${var.environment}${var.location_short}${var.name}velero${var.unique_suffix}"
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = data.azurerm_resource_group.this.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "velero" {
  storage_account_name  = azurerm_storage_account.velero.name
  name                  = "backup"
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "velero" {
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  name                = "uai-${var.environment}-${var.location_short}-${var.name}-velero"
}

resource "azurerm_role_assignment" "velero_msi" {
  scope                = azurerm_user_assigned_identity.velero.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azuread_group.aks_managed_identity.id
}

resource "azurerm_role_assignment" "external_storage_contributor" {
  scope                = azurerm_storage_account.velero.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

resource "azurerm_role_assignment" "velero_rg_read" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}
