resource "azurerm_user_assigned_identity" "grafana_alloy" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-grafana_alloy-wi"
}

resource "azurerm_federated_identity_credential" "grafana_alloy" {
  name                = azurerm_user_assigned_identity.grafana_alloy.name
  resource_group_name = azurerm_user_assigned_identity.grafana_alloy.resource_group_name
  parent_id           = azurerm_user_assigned_identity.grafana_alloy.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:grafana_alloy:grafana_alloy-secret-mount"
}

resource "azurerm_key_vault_access_policy" "grafana_alloy" {
  key_vault_id       = var.key_vault_id
  tenant_id          = azurerm_user_assigned_identity.grafana_alloy.tenant_id
  object_id          = azurerm_user_assigned_identity.grafana_alloy.principal_id
  secret_permissions = ["Get"]
}
