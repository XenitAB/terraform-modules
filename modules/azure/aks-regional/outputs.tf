output "aad_pod_identity" {
  description = "aad-pod-identity user assigned identities"
  value       = local.aad_pod_identity
}

output "namespaces" {
  description = "Kubernetes namespaces"
  value       = var.namespaces
}

output "aks_authorized_ips" {
  description = "IP addresses authorized for API communication to Azure Kubernetes Service"
  value = concat(
    var.aks_authorized_ips,
    local.aks_public_ip_prefix_ips,
  )
}

output "aks_public_ip_prefix_ids" {
  description = "Azure Kubernetes Service IP Prefixes"
  value       = local.aks_public_ip_prefix_ids
}

output "dns_zone" {
  description = "DNS Zone to be used with external-dns"
  value       = var.dns_zone
}

output "ssh_public_key" {
  description = "SSH public key to add to servers"
  value       = tls_private_key.ssh_key.public_key_openssh
}

output "xenit" {
  description = "Configuration used by monitoring solution to get authentication credentials"
  value = {
    azure_key_vault_name = data.azurerm_key_vault.core.name
    identity = {
      client_id   = azurerm_user_assigned_identity.xenit.client_id
      resource_id = azurerm_user_assigned_identity.xenit.id
      tenant_id   = data.azurerm_client_config.current.tenant_id
    }
  }
}

output "aks_managed_identity_group_id" {
  description = "The group id of aks managed identity"
  value       = var.aks_managed_identity
}

output "log_eventhub_name" {
  description = "The eventhub name for k8s logs"
  value       = azurerm_eventhub.this.name
}

output "log_eventhub_hostname" {
  description = "The eventhub hostname for k8s logs"
  value       = "${azurerm_eventhub_namespace.this.name}.servicebus.windows.net:9093"
}

output "log_eventhub_authorization_rule_id" {
  description = "The authoritzation rule id for event hub"
  value       = azurerm_eventhub_namespace_authorization_rule.aks.id
}
