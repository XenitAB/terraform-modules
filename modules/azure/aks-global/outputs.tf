output "aadGroups" {
  value = {
    aadGroupView         = azuread_group.aadGroupView
    aadGroupEdit         = azuread_group.aadGroupEdit
    aadGroupClusterAdmin = azuread_group.aadGroupClusterAdmin
    aadGroupClusterView  = azuread_group.aadGroupClusterView
  }
}

output "aadPodIdentity" {
  value = azurerm_user_assigned_identity.userAssignedIdentityNs
}

output "acr" {
  value = azurerm_container_registry.acr
}

output "namespaces" {
  value = var.namespaces
}

output "aksAuthorizedIps" {
  value = concat(
    var.aks_authorized_ips,
    local.aks_pip_prefixes,
  )
}

output "aksPipPrefixes" {
  value = azurerm_public_ip_prefix.aks
}
