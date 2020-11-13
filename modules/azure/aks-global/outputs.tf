output "aad_groups" {
  description = "Azure AD groups"
  value = local.aad_groups
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
  value = local.aks_public_ip_prefix_ids
}

output "dns_zone" {
  description = "DNS Zone to be used with external-dns"
  value       = var.dns_zone
}

output "helm_operator_credentials" {
  description = ""
  value = {
    client_id = azuread_service_principal.helm_operator.application_id
    secret    = random_password.helm_operator.result
  }
}
