resource "azurerm_user_assigned_identity" "azure_metrics" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-azure-metrics-wi"
}

resource "azurerm_federated_identity_credential" "azure_metrics" {
  name                = azurerm_user_assigned_identity.azure_metrics.name
  resource_group_name = azurerm_user_assigned_identity.azure_metrics.resource_group_name
  parent_id           = azurerm_user_assigned_identity.azure_metrics.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:azure-metrics:azure-metrics-exporter"
}