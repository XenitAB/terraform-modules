resource "helm_release" "argocd_hub_setup" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if length(var.argocd_config.azure_tenants) > 0
  }

  depends_on  = [helm_release.argocd]
  chart       = "${path.module}/charts/argocd-hub-setup"
  name        = "argocd-hub-setup"
  namespace   = "argocd"
  max_history = 3
  values      = [yamlencode(merge({ "uai_id" : azurerm_user_assigned_identity.argocd.principal_id }, var.argocd_config))]

  set_sensitive {
    name  = "repositories"
    value = yamlencode(local.key_vault_secret_values)
  }
}

resource "helm_release" "argocd_spoke_setup" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if length(var.argocd_config.azure_tenants) == 0
  }

  depends_on  = [helm_release.argocd]
  chart       = "${path.module}/charts/argocd-spoke-setup"
  name        = "argocd-spoke-setup"
  namespace   = "argocd"
  max_history = 3
  values      = [yamlencode({ "uai_id" : azurerm_user_assigned_identity.argocd.principal_id })]
}