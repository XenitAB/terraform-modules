module "automation" {
  depends_on = [azurerm_kubernetes_cluster.this]

  for_each = {
    for s in ["automation"] :
    s => s
    if var.aks_automation_enabled
  }

  source = "./automation"

  aks_managed_identity       = var.aad_groups.aks_managed_identity.id
  aks_name                   = azurerm_kubernetes_cluster.this.name
  aks_automation_config      = var.aks_automation_config
  aks_joblogs_retention_days = var.aks_joblogs_retention_days
  location_short             = var.location_short
  resource_group_name        = data.azurerm_resource_group.this.name
  environment                = var.environment
  storage_account_id         = data.azurerm_storage_account.log.id
}