resource "azurerm_user_assigned_identity" "grafana_k8s_monitor_billable" {
  name                = "uai-${var.cluster_id}-grafana-k8s-monitor-billable-wi"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "grafana_k8s_monitor_billable" {
  name                = azurerm_user_assigned_identity.grafana_k8s_monitor_billable.name
  resource_group_name = azurerm_user_assigned_identity.grafana_k8s_monitor_billable.resource_group_name
  parent_id           = azurerm_user_assigned_identity.grafana_k8s_monitor_billable.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:grafana-k8s-monitoring-billable:grafana-k8s-monitoring-billable-alloy-metrics"
}

resource "azurerm_key_vault_access_policy" "grafana_k8s_monitor_billable" {
  key_vault_id       = var.key_vault_id
  tenant_id          = azurerm_user_assigned_identity.grafana_k8s_monitor_billable.tenant_id
  object_id          = azurerm_user_assigned_identity.grafana_k8s_monitor_billable.principal_id
  secret_permissions = ["Get"]
}
