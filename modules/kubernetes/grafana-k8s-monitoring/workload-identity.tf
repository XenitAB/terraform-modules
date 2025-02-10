resource "azurerm_user_assigned_identity" "grafana_k8s_monitor" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-grafana-k8s-monitor-wi"
}

resource "azurerm_federated_identity_credential" "grafana_k8s_monitor" {
  name                = azurerm_user_assigned_identity.grafana_k8s_monitor.name
  resource_group_name = azurerm_user_assigned_identity.grafana_k8s_monitor.resource_group_name
  parent_id           = azurerm_user_assigned_identity.grafana_k8s_monitor.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:grafana-k8s-monitoring:grafana-k8s-monitoring-alloy-metrics"
}

resource "azurerm_key_vault_access_policy" "grafana_k8s_monitor" {
  key_vault_id       = var.key_vault_id
  tenant_id          = azurerm_user_assigned_identity.grafana_k8s_monitor.tenant_id
  object_id          = azurerm_user_assigned_identity.grafana_k8s_monitor.principal_id
  secret_permissions = ["Get"]
}