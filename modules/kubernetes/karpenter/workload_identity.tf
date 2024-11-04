resource "azurerm_user_assigned_identity" "karpenter" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.aks_config.cluster_id}-karpenter-wi"
}

resource "azurerm_role_assignment" "karpenter_contributor" {
  for_each = {
    for role in ["Virtual Machine Contributor", "Network Contributor", "Managed Identity Operator"] :
    role => role
  }
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = each.key
  principal_id         = azurerm_user_assigned_identity.karpenter.principal_id
}

resource "azurerm_federated_identity_credential" "karpenter" {
  name                = azurerm_user_assigned_identity.karpenter.name
  resource_group_name = azurerm_user_assigned_identity.karpenter.resource_group_name
  parent_id           = azurerm_user_assigned_identity.karpenter.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_config.oidc_issuer_url
  subject             = "system:serviceaccount:kube-system:karpenter-sa"
}