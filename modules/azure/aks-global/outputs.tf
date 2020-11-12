output "azure_ad_group" {
  description = "Azure AD groups"
  value = {
    view          = azuread_group.view
    edit          = azuread_group.edit
    cluster_admin = azuread_group.cluster_admin
    cluster_view  = azuread_group.cluster_view
  }
}

output "aad_pod_identity" {
  description = "aad-pod-identity user assigned identities"
  value       = azurerm_user_assigned_identity.aad_pod_identity
}

output "acr" {
  description = "Azure Container Registry"
  value       = azurerm_container_registry.acr
}

output "namespaces" {
  description = "Kubernetes namespaces"
  value       = var.namespaces
}

output "aks_authorized_ips" {
  description = "IP addresses authorized for API communication to Azure Kubernetes Service"
  value = concat(
    var.aks_authorized_ips,
    local.aks_public_ip_prefixes,
  )
}

output "aks_public_ip_prefixes" {
  description = "Azure Kubernetes Service IP Prefixes"
  value       = azurerm_public_ip_prefix.aks
}

output "dns_zone" {
  description = "DNS Zone to be used with external-dns"
  value       = var.dns_zone
}
