resource "helm_release" "argoc_setup" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if length(var.argocd_config.clusters) > 0
  }

  depends_on  = [helm_release.argocd]
  chart       = "${path.module}/charts/argocd-setup"
  name        = "argocd-setup"
  namespace   = "argocd"
  max_history = 3
  values      = [yamlencode(merge({ "uai_id" : azurerm_user_assigned_identity.argocd.principal_id }, var.argocd_config))]

  set_sensitive {
    name  = "secrets"
    value = local.key_vault_secret_values
  }
}