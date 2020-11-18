output "aad_groups" {
  description = "Azure AD groups"
  value       = local.aad_groups
}

output "aad_pod_identity" {
  description = "aad-pod-identity user assigned identities"
  value       = local.aad_pod_identity
}

output "acr_name" {
  description = "Azure Container Registry Name"
  value       = azurerm_container_registry.acr.name
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

output "helm_operator_credentials" {
  description = "Credentials meant to be used by Helm Operator"
  sensitive   = true
  value = {
    client_id = azuread_service_principal.helm_operator.application_id
    secret    = random_password.helm_operator.result
  }
}

output "external_dns_identity" {
  value = {
    client_id = azurerm_user_assigned_identity.external_dns.client_id
    resource_id = azurerm_user_assigned_identity.external_dns.id
  }
}
