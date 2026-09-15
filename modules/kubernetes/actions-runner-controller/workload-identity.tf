# The controller never talks to Azure -- only the runner scale set's ExternalSecret
# does, via the shared identity already used by control-plane-logs and argo-workflows
# for Key Vault access. Reusing it avoids provisioning + RBAC-granting a new identity.
data "azurerm_user_assigned_identity" "xenit" {
  count               = var.arc_runner_set_config != null ? 1 : 0
  resource_group_name = var.resource_group_name
  name                = "uai-${var.environment}-${var.location_short}-${var.aks_name}-xenit"
}

resource "azurerm_federated_identity_credential" "arc_external_secrets" {
  count               = var.arc_runner_set_config != null ? 1 : 0
  name                = "uai-${var.environment}-${var.location_short}-${var.aks_name}-arc-external-secrets-wi"
  resource_group_name = data.azurerm_user_assigned_identity.xenit[0].resource_group_name
  parent_id           = data.azurerm_user_assigned_identity.xenit[0].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:${local.runners_namespace}:${local.eso_service_account_name}"
}

