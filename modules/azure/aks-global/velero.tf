resource "azurerm_storage_account" "backup" {
  name                     = "strg${var.environment}${var.location_short}${var.aks_name}bck"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_container" "backup" {
  storage_account_name  = azurerm_storage_account.backup.name
  name                  = "backup"
  container_access_type = "private"
}

resource "azuread_application" "backup" {
  name = "${local.service_principal_name_prefix}${local.group_name_separator}${var.subscription_name}${local.group_name_separator}${var.environment}${local.group_name_separator}${var.aks_name}${local.group_name_separator}k8sbck"
}

resource "azuread_service_principal" "backup" {
  application_id = azuread_application.backup.application_id
}

resource "azuread_application_password" "backup" {
  application_object_id = azuread_application.backup.id
  value                 = random_password.backup.result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "random_password" "backup" {
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = azuread_service_principal.backup.id
  }
}

resource "azurerm_key_vault_secret" "backup" {
  name = "kubernetes-backup"
  value = base64encode(jsonencode({
    AZURE_TENANT_ID                 = data.azurerm_subscription.current.tenant_id
    AZURE_SUBSCRIPTION_ID           = data.azurerm_subscription.current.subscription_id
    AZURE_RESOURCE_GROUP            = data.azurerm_resource_group.rg.name
    AZURE_CLIENT_ID                 = azuread_service_principal.backup.application_id
    AZURE_CLIENT_SECRET             = random_password.backup.result
    AZURE_STORAGE_ACCOUNT           = azurerm_storage_account.backup.name
    AZURE_STORAGE_ACCOUNT_CONTAINER = azurerm_storage_container.backup.name
  }))
  key_vault_id = data.azurerm_key_vault.core.id
}

resource "azurerm_role_assignment" "backup" {
  scope                = azurerm_storage_account.backup.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.backup.object_id
}
