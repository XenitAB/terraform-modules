terraform {}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "random" {}

provider "tls" {}

module "aks_regional" {
  source = "../../../modules/azure/aks-regional"

  environment                   = "dev"
  location_short                = "we"
  name                          = "xks"
  subscription_name             = "xks"
  core_name                     = "core"
  unique_suffix                 = "1234"
  aks_managed_identity_group_id = "1337"
  azuread_group_edit_id         = "1337"
  azuread_group_view_id         = "1337"
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

  dns_zone           = ["example.io"]
  aks_authorized_ips = ["0.0.0.0/0"]
}
