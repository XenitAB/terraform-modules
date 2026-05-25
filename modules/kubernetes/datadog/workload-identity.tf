resource "azurerm_user_assigned_identity" "datadog" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-datadog-wi"
}

resource "azurerm_federated_identity_credential" "datadog" {
  name                = azurerm_user_assigned_identity.datadog.name
  resource_group_name = azurerm_user_assigned_identity.datadog.resource_group_name
  parent_id           = azurerm_user_assigned_identity.datadog.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:datadog:datadog-secret-mount"
}

resource "azurerm_key_vault_access_policy" "datadog" {
  count              = var.key_vault_rbac_enabled ? 0 : 1
  key_vault_id       = var.key_vault_id
  tenant_id          = azurerm_user_assigned_identity.datadog.tenant_id
  object_id          = azurerm_user_assigned_identity.datadog.principal_id
  secret_permissions = ["Get"]
}

# RBAC equivalent of the access policy above. Datadog only needs to read
# secrets, so `Key Vault Secrets User` is the least-privilege equivalent of
# `secret_permissions = ["Get"]`.
resource "azurerm_role_assignment" "datadog_kv_secrets_user" {
  count                = var.key_vault_rbac_enabled ? 1 : 0
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.datadog.principal_id
  principal_type       = "ServicePrincipal"
}