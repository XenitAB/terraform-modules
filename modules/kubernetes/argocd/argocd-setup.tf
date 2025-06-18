resource "helm_release" "argocd_hub_setup" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if contains(["Hub"], var.argocd_config.cluster_role)
  }

  depends_on  = [helm_release.argocd]
  chart       = "${path.module}/charts/argocd-hub-setup"
  name        = "argocd-hub-setup"
  namespace   = "argocd"
  version     = "0.1.3"
  max_history = 3
  values = [
    yamlencode(merge(
      var.argocd_config,
      var.fleet_infra_config,
      { "uai_id" : azurerm_user_assigned_identity.argocd.principal_id },
      { "secrets" : local.key_vault_secret_values }
    ))
  ]

  #set_sensitive {
  #  name  = "repositories"
  #  value = yamlencode(local.key_vault_secret_values)
  #}
}

resource "helm_release" "argocd_spoke_setup" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if contains(["Hub-Spoke", "Spoke"], var.argocd_config.cluster_role)
  }

  depends_on  = [helm_release.argocd]
  chart       = "${path.module}/charts/argocd-spoke-setup"
  name        = "argocd-spoke-setup"
  max_history = 3
  values      = [yamlencode({ "uai_id" : azurerm_user_assigned_identity.argocd.principal_id })]
}