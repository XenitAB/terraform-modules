output "aad_groups" {
  description = "Azure AD groups"
  value       = local.aad_groups
}

output "aad_pod_identity" {
  description = "aad-pod-identity user assigned identities"
  value       = local.aad_pod_identity
}

output "namespaces" {
  description = "Kubernetes namespaces"
  value       = var.namespaces
}

output "dns_zone" {
  description = "DNS Zone to be used with external-dns"
  value       = var.dns_zone
}

output "helm_operator_credentials" {
  description = "Credentials meant to be used by Helm Operator"
  sensitive   = true
  value = {
    client_id = azuread_service_principal.helm_operator.application_id
    secret    = azuread_application_password.helm_operator.value
  }
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
