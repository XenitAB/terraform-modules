output "kube_config" {
  description = "Kube config for the created AKS cluster"
  sensitive   = true
  value = {
    host                   = azurerm_kubernetes_cluster.this.kube_config_raw.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config_raw.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config_raw.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config_raw.cluster_ca_certificate)
  }
}
