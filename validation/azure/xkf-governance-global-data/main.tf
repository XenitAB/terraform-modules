terraform {}

provider "azuread" {}

module "xks_global" {
  source = "../../../modules/azure/xkf-governance-global-data"

  environment       = "dev"
  subscription_name = "xks"

  namespaces = [
    {
      name = "team1"
      labels = {
        "test" = "test"
      }
      flux = {
        enabled = true
        repo    = "repo"
      }
    }
  ]

  group_name_prefix = "aks"
}
