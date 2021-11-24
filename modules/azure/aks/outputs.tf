output "kube_config" {
  description = "Kube config for the created AKS cluster"
  sensitive   = true
  value = {
    host                   = azurerm_kubernetes_cluster.this.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config[0].cluster_ca_certificate)
  }
}

output "azure_metrics_identity" {
  description = "MSI authentication identity for Azure Metrics"
  value = {
    client_id   = azurerm_user_assigned_identity.az_metrics.client_id
    resource_id = azurerm_user_assigned_identity.az_metrics.id
  }
}
