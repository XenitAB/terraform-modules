terraform {}

provider "azuread" {}

module "xks_global" {
  source = "../../../modules/azure/xks-global"

  cloud_provider    = "azure"
  environment       = "dev"
  subscription_name = "xks"

  namespaces = [
    {
      name                    = "team1"
      delegate_resource_group = true
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
