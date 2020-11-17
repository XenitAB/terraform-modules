locals {
  resource_group_name  = var.resource_group_name == "" ? "rg-${var.environment}-${var.location_short}-${var.name}" : var.resource_group_name
  storage_account_name = var.storage_account_name == "" ? "strg${var.environment}${var.location_short}${var.name}loki" : var.storage_account_name
}
