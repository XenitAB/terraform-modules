output "acr_name" {
  description = "Azure Container Registry Name"
  value       = azurerm_container_registry.acr.name
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

output "ssh_public_key" {
  description = "SSH public key to add to servers"
  value       = tls_private_key.ssh_key.public_key_openssh
}

output "velero" {
  description = "Velero configuration"
  value = {
    azure_storage_account_name      = azurerm_storage_account.velero.name
    azure_storage_account_container = azurerm_storage_container.velero.name
    identity = {
      client_id   = azurerm_user_assigned_identity.velero.client_id
      resource_id = azurerm_user_assigned_identity.velero.id
    }
  }
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

output "trivy_identity" {
  description = "MSI authentication identity for Trivy image scaning"
  value = {
    client_id   = azurerm_user_assigned_identity.trivy.client_id
    resource_id = azurerm_user_assigned_identity.trivy.id
  }
}

output "azad_kube_proxy" {
  description = "The Azure AD Application config for azad-kube-proxy"
  value = {
    azure_ad_app = module.azad_kube_proxy.data
  }
  sensitive = true
}
