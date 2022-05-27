terraform {}

provider "azuread" {}

module "xks_global" {
  source = "../../../modules/azure/xks-global"

  cloud_provider    = "azure"
  environment       = "dev"
  subscription_name = "xks"
  azad_kube_proxy_config = {
    cluster_name_prefix = "aks"
    proxy_url_override  = ""
    dns_zone            = "test.io"
  }
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
