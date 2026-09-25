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
  key_vault_id       = var.key_vault_id
  tenant_id          = azurerm_user_assigned_identity.datadog.tenant_id
  object_id          = azurerm_user_assigned_identity.datadog.principal_id
  secret_permissions = ["Get"]

  lifecycle {
    # OpenTofu >= 1.11 `enabled` meta-argument. Disabled when the target
    # Key Vault uses RBAC authorization; the paired `azurerm_role_assignment`
    # below takes over in that case.
    enabled = !var.key_vault_rbac_enabled
  }
}

# RBAC equivalent of the access policy above. Datadog only needs to read
# secrets, so `Key Vault Secrets User` is the least-privilege equivalent of
# `secret_permissions = ["Get"]`. It is always created so the grant is in
# place before the vault is flipped to RBAC mode; Azure ignores it while the
# vault is still in access-policy mode.
resource "azurerm_role_assignment" "datadog_kv_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.datadog.principal_id
  principal_type       = "ServicePrincipal"
}
