locals {
  spNamePrefix       = "sp"
  groupNameSeparator = "-"
  aadGroupPrefix     = "az"
  aksGroupNamePrefix = "aks"
  aksAadApps = {
    aksClientAppClientId     = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksClientAppClientId
    aksClientAppPrincipalId  = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksClientAppPrincipalId
    aksClientAppClientSecret = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksClientAppClientSecret
    aksServerAppClientId     = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksServerAppClientId
    aksServerAppClientSecret = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksServerAppClientSecret
  }
  aadGroups        = data.terraform_remote_state.aksGlobal.outputs.aadGroups
  aadPodIdentity   = data.terraform_remote_state.aksGlobal.outputs.aadPodIdentity
  acr              = data.terraform_remote_state.aksGlobal.outputs.acr
  k8sNamespaces    = data.terraform_remote_state.aksGlobal.outputs.k8sNamespaces
  aksAuthorizedIps = data.terraform_remote_state.aksGlobal.outputs.aksAuthorizedIps
  aksPipPrefixId   = data.terraform_remote_state.aksGlobal.outputs.aksPipPrefixes[0].id
  helmOperator     = jsondecode(data.azurerm_key_vault_secret.kvSecretHelmOperator.value)
}
