output "client_id" {
  description = "Client ID of the managed identity"
  value       = azurerm_user_assigned_identity.grafana_k8s_monitor_billable.client_id
}
