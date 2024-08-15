locals {
  aks_name_suffix = var.aks_name_suffix != null ? var.aks_name_suffix : ""
}

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

resource "azurerm_role_assignment" "azure_metrics" {
  scope                = azurerm_user_assigned_identity.azure_metrics.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_managed_identity
}

resource "azurerm_role_assignment" "azure_metrics_aks_reader" {
  scope                = "/subscriptions/${var.subscription_id}/resourcegroups/${var.resource_group_name}/providers/Microsoft.ContainerService/managedClusters/aks-${var.environment}-${var.location_short}-${var.aks_name}${local.aks_name_suffix}"
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_user_assigned_identity.azure_metrics.principal_id
}

resource "azurerm_role_assignment" "azure_metrics_lb_reader" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/mc_${var.resource_group_name}_aks-${var.environment}-${var.location_short}-${var.aks_name}${local.aks_name_suffix}_${var.location}/providers/Microsoft.Network/loadBalancers/kubernetes"
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_user_assigned_identity.azure_metrics.principal_id
}