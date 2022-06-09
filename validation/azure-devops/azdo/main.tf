terraform {}

module "azad_kube_proxy" {
  source = "../../../modules/azure-devops/azdo"

  environment                  = "dev"
  subscription_name            = "xks"
  display_name                 = "sp-sub-all-owner"
  azuredevops_organization     = "org1"
  azuredevops_project          = "xks"
  location                     = "West Europe"
  location_short               = "we"
  core_name                    = "aks"
  unique_suffix                = "1337"
  azdo_pat_name                = "my-super-secret-pat"
}
