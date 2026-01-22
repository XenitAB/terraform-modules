module "automation" {
  depends_on = [azurerm_kubernetes_cluster.this]

  for_each = {
    for s in ["automation"] :
    s => s
    if var.aks_automation_enabled
  }

  source = "./automation"

  aks_id                     = azurerm_kubernetes_cluster.this.id
  aks_managed_identity       = var.aad_groups.aks_managed_identity.id
  aks_name                   = azurerm_kubernetes_cluster.this.name
  aks_automation_config      = var.aks_automation_config
  aks_joblogs_retention_days = var.aks_joblogs_retention_days
  alerts_enabled             = var.alerts_enabled
  alerts_resource_group_name = data.azurerm_resource_group.log.name
  alert_name                 = "audit log${var.environment}${var.location_short}${var.name}${var.unique_suffix} storage account missing data"
  location                   = var.location
  location_short             = var.location_short
  notification_email         = var.notification_email
  resource_group_name        = data.azurerm_resource_group.this.name
  environment                = var.environment
  storage_account_id         = data.azurerm_storage_account.log.id
}