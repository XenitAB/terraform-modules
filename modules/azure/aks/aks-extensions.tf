resource "azurerm_kubernetes_cluster_extension" "kv" {
  name           = "azure-keyvault-secrets-provider"
  cluster_id     = azurerm_kubernetes_cluster.this.id
  extension_type = "azure-keyvault-secrets-provider"
}
