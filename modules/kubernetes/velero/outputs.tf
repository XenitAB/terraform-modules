output "velero" {
  description = "Velero configuration"
  value = {
    azure_storage_account_name      = azurerm_storage_account.velero.name
    azure_storage_account_container = azurerm_storage_container.velero.name
    identity = {
      client_id   = azurerm_user_assigned_identity.velero.client_id
      resource_id = azurerm_user_assigned_identity.velero.id
    }
  }
}