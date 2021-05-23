terraform {}

provider "azurerm" {
  features {}
}

module "aks_power_schedule" {
  source = "../../../modules/azure/aks-power-schedule"

  environment                  = "dev"
  location_short               = "we"
  unique_suffix                = "9876"
  name                         = "aks"
  resource_group_name          = "fnlab"
  aks_cluster_name             = "fnlab"
  shutdown_aks_cron_expression = "*/5 * * * * *"
  shutdown_aks_disabled        = false
}
