terraform {}

provider "azurerm" {
  features {}
}

module "aks_shutdown_scheduler" {
  source = "../../../modules/azure/aks-shutdown-scheduler"

  environment                  = "dev"
  location_short               = "we"
  unique_suffix                = "1234"
  name                         = "aks"
  resource_group_name          = "fnlab"
  shutdown_aks_cron_expression = "*/5 * * * * *"
  shutdown_aks_disabled        = false
}
