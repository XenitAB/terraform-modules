output "workload_identity" {
  description = "Workload identity created for ARC, when enabled. Reuse this for runner scale sets deployed alongside the controller that need Azure access."
  value = var.enabled ? {
    client_id    = azurerm_user_assigned_identity.arc[0].client_id
    principal_id = azurerm_user_assigned_identity.arc[0].principal_id
    resource_id  = azurerm_user_assigned_identity.arc[0].id
  } : null
}
