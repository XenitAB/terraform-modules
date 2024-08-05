resource "azurerm_user_assigned_identity" "grafana-alloy" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-grafana-alloy-wi"
}

resource "azurerm_federated_identity_credential" "grafana-alloy" {
  name                = azurerm_user_assigned_identity.grafana-alloy.name
  resource_group_name = azurerm_user_assigned_identity.grafana-alloy.resource_group_name
  parent_id           = azurerm_user_assigned_identity.grafana-alloy.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:grafana-alloy:grafana-alloy-secret-mount"
}

resource "azurerm_key_vault_access_policy" "grafana-alloy" {
  key_vault_id       = var.key_vault_id
  tenant_id          = azurerm_user_assigned_identity.grafana-alloy.tenant_id
  object_id          = azurerm_user_assigned_identity.grafana-alloy.principal_id
  secret_permissions = ["Get"]
}