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
  count              = var.key_vault_rbac_enabled ? 0 : 1
  key_vault_id       = data.azurerm_key_vault.core.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_user_assigned_identity.xenit.principal_id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}

# RBAC equivalent of the access policy above. Created when
# `key_vault_rbac_enabled = true` (i.e. the target Key Vault has
# `enable_rbac_authorization = true`). `Key Vault Administrator` is the
# closest equivalent to the previous full key + secret permission set.
resource "azurerm_role_assignment" "xenit_kv" {
  count                = var.key_vault_rbac_enabled ? 1 : 0
  scope                = data.azurerm_key_vault.core.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.xenit.principal_id
  principal_type       = "ServicePrincipal"
}
