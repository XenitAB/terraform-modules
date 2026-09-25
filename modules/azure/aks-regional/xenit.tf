resource "azurerm_user_assigned_identity" "xenit" {
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  name                = "uai-${var.environment}-${var.location_short}-${var.name}-xenit"
}

resource "azurerm_role_assignment" "xenit" {
  scope                = azurerm_user_assigned_identity.xenit.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_managed_identity
}

resource "azurerm_key_vault_access_policy" "xenit" {
  key_vault_id       = data.azurerm_key_vault.core.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_user_assigned_identity.xenit.principal_id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions

  lifecycle {
    # OpenTofu >= 1.11 `enabled` meta-argument. Disabled when the target
    # Key Vault uses RBAC authorization; the paired `azurerm_role_assignment`
    # below takes over in that case.
    enabled = !var.key_vault_rbac_enabled
  }
}

# RBAC equivalent of the access policy above. `Key Vault Administrator` is
# the closest equivalent to the previous full key + secret permission set.
# It is always created so the grant is in place before the vault is flipped
# to RBAC mode; Azure ignores it while the vault is still in access-policy
# mode.
resource "azurerm_role_assignment" "xenit_kv" {
  scope                = data.azurerm_key_vault.core.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.xenit.principal_id
  principal_type       = "ServicePrincipal"
}
