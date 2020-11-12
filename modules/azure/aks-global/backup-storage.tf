resource "azurerm_storage_account" "storageAccountBackup" {
  name                     = "strg${var.environmentShort}${var.locationShort}${var.aksCommonName}bck"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_container" "storageContainerBackup" {
  storage_account_name  = azurerm_storage_account.storageAccountBackup.name
  name                  = "backup"
  container_access_type = "private"
}

resource "azuread_application" "aadAppK8sbck" {
  name = "${local.spNamePrefix}${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${var.aksCommonName}${local.groupNameSeparator}k8sbck"
}

resource "azuread_service_principal" "aadAppK8sbck" {
  application_id = azuread_application.aadAppK8sbck.application_id
}

resource "azuread_application_password" "aadAppK8sbck" {
  application_object_id = azuread_application.aadAppK8sbck.id
  value                 = random_password.aadAppK8sbck.result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "random_password" "aadAppK8sbck" {
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = azuread_service_principal.aadAppK8sbck.id
  }
}

resource "azurerm_key_vault_secret" "k8sbckSecret" {
  name = "kubernetes-backup"
  value = base64encode(jsonencode({
    AZURE_TENANT_ID                 = data.azurerm_subscription.current.tenant_id
    AZURE_SUBSCRIPTION_ID           = data.azurerm_subscription.current.subscription_id
    AZURE_RESOURCE_GROUP            = data.azurerm_resource_group.rg.name
    AZURE_CLIENT_ID                 = azuread_service_principal.aadAppK8sbck.application_id
    AZURE_CLIENT_SECRET             = random_password.aadAppK8sbck.result
    AZURE_STORAGE_ACCOUNT           = azurerm_storage_account.storageAccountBackup.name
    AZURE_STORAGE_ACCOUNT_CONTAINER = azurerm_storage_container.storageContainerBackup.name
  }))
  key_vault_id = data.azurerm_key_vault.coreKv.id
}

resource "azurerm_role_assignment" "k8sbckAssignment" {
  scope                = azurerm_storage_account.storageAccountBackup.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aadAppK8sbck.object_id
}
