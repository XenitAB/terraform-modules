resource "azurerm_user_assigned_identity" "argocd" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-argocd-wi"
}

resource "azurerm_role_assignment" "argocd_admin" {
  scope                = var.aks_cluster_id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = azurerm_user_assigned_identity.argocd.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_federated_identity_credential" "argocd_server" {
  for_each = {
    for s in split(",", var.argocd_config.oidc_issuer_url) :
    s => s
    if var.argocd_config.oidc_issuer_url != ""
  }

  name                = "argocd-server"
  resource_group_name = azurerm_user_assigned_identity.argocd.resource_group_name
  parent_id           = azurerm_user_assigned_identity.argocd.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = each.value
  subject             = "system:serviceaccount:argocd:argocd-server"
}

resource "azurerm_federated_identity_credential" "argocd_application_controller" {
  for_each = {
    for s in split(",", var.argocd_config.oidc_issuer_url) :
    s => s
    if var.argocd_config.oidc_issuer_url != ""
  }

  name                = "argocd-application-controller"
  resource_group_name = azurerm_user_assigned_identity.argocd.resource_group_name
  parent_id           = azurerm_user_assigned_identity.argocd.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = each.value
  subject             = "system:serviceaccount:argocd:argocd-application-controller"
}

resource "azurerm_key_vault_access_policy" "argocd" {
  key_vault_id       = data.azurerm_key_vault.core.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_user_assigned_identity.argocd.principal_id
  key_permissions    = local.key_vault_default_permissions.key_permissions
  secret_permissions = local.key_vault_default_permissions.secret_permissions
}