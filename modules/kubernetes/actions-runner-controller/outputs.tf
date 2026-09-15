output "eso_client_id" {
  description = "Client ID of the shared identity federated for the runner scale set's ExternalSecret. Null if arc_runner_set_config was not set."
  value       = var.arc_runner_set_config != null ? data.azurerm_user_assigned_identity.xenit[0].client_id : null
}
