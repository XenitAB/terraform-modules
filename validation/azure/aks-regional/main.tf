terraform {}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "random" {}

provider "tls" {}

module "aks_regional" {
  source = "../../../modules/azure/aks-regional"

  environment       = "dev"
  location_short    = "we"
  name              = "xks"
  subscription_name = "xks"
  core_name         = "core"
  unique_suffix     = "1234"
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
  aks_managed_identity = "id"

  dns_zone           = ["example.io"]
  aks_authorized_ips = ["0.0.0.0/0"]
}
