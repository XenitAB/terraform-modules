# Azure DevOps Proxy
module "azdo_proxy" {
  for_each = {
    for s in ["azdo-proxy"] :
    s => s
    if var.azdo_proxy_enabled == true
  }

  source = "github.com/xenitab/terraform-modules//modules/kubernetes/azdo-proxy?ref=feature%2Finit"

  providers = {
    azurerm    = azurem
    kubernetes = kubernetes
    helm       = helm
  }

  azure_devops_organization = var.azure_devops_organization

  azure_devops_pat_keyvault = {
    read_azure_devops_pat_from_azure_keyvault = true
    azure_keyvault_id                         = data.azurerm_key_vault.core.id
    key                                       = "azure-devops-pat"
  }

  namespaces = [for ns in var.namespaces : {
    name = ns.name
    flux = ns.flux
  }]
}
