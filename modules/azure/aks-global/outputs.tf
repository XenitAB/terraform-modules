output "aad_groups" {
  description = "Azure AD groups"
  value       = local.aad_groups
}

output "namespaces" {
  description = "Kubernetes namespaces"
  value       = var.namespaces
}

output "dns_zone" {
  description = "DNS Zone to be used with external-dns"
  value       = var.dns_zone
}

output "external_dns_identity" {
  description = "MSI authentication identity for External DNS"
  value = {
    client_id   = azurerm_user_assigned_identity.external_dns.client_id
    resource_id = azurerm_user_assigned_identity.external_dns.id
  }
}

output "aks_managed_identity_group_id" {
  description = "The group id of aks managed identity"
  value       = azuread_group.aks_managed_identity.id
}
