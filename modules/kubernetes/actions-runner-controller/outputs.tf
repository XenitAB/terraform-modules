output "workload_identity" {
  description = "Workload identity created for ARC. Reuse this for runner scale sets deployed alongside the controller that need Azure access."
  value = {
    client_id    = azurerm_user_assigned_identity.arc.client_id
    principal_id = azurerm_user_assigned_identity.arc.principal_id
    resource_id  = azurerm_user_assigned_identity.arc.id
  }
}
