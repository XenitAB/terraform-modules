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
  name                = azurerm_user_assigned_identity.argocd.name
  resource_group_name = azurerm_user_assigned_identity.argocd.resource_group_name
  parent_id           = azurerm_user_assigned_identity.argocd.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.argocd_config.oidc_issuer_url
  subject             = "system:serviceaccount:argocd:argocd-server"
}

resource "azurerm_federated_identity_credential" "argocd_application_controller" {
  name                = azurerm_user_assigned_identity.argocd.name
  resource_group_name = azurerm_user_assigned_identity.argocd.resource_group_name
  parent_id           = azurerm_user_assigned_identity.argocd.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.argocd_config.oidc_issuer_url
  subject             = "system:serviceaccount:argocd:argocd-application-controller"
}