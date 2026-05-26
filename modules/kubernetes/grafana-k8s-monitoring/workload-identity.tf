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

  lifecycle {
    # OpenTofu >= 1.11 `enabled` meta-argument. Disabled when the target
    # Key Vault uses RBAC authorization; the paired `azurerm_role_assignment`
    # below takes over in that case.
    enabled = !var.key_vault_rbac_enabled
  }
}

# RBAC equivalent of the access policy above. The agent only needs to read
# secrets, so `Key Vault Secrets User` is the least-privilege equivalent of
# `secret_permissions = ["Get"]`.
resource "azurerm_role_assignment" "grafana_k8s_monitor_kv_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.grafana_k8s_monitor.principal_id
  principal_type       = "ServicePrincipal"

  lifecycle {
    enabled = var.key_vault_rbac_enabled
  }
}