# The controller never talks to Azure -- only the runner scale set's ExternalSecret
# does. It gets its own dedicated identity so ARC's Key Vault access is isolated from
# the shared "xenit" identity used by the rest of the platform.
resource "azurerm_user_assigned_identity" "arc" {
  count               = var.arc_runner_set_config != null ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.environment}-${var.location_short}-${var.aks_name}-arc"
}

resource "azurerm_federated_identity_credential" "arc_external_secrets" {
  count               = var.arc_runner_set_config != null ? 1 : 0
  name                = "external-secrets"
  resource_group_name = azurerm_user_assigned_identity.arc[0].resource_group_name
  parent_id           = azurerm_user_assigned_identity.arc[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:${local.runners_namespace}:${local.eso_service_account_name}"
}

# The core vault authorizes via access policies, which are vault-wide per
# operation -- this grants secret read across the whole vault. Point ARC at a
# dedicated vault if per-secret isolation is required.
resource "azurerm_key_vault_access_policy" "arc" {
  count              = var.arc_runner_set_config != null ? 1 : 0
  key_vault_id       = var.key_vault_id
  tenant_id          = var.azure_tenant_id
  object_id          = azurerm_user_assigned_identity.arc[0].principal_id
  secret_permissions = ["Get", "List"]
}

