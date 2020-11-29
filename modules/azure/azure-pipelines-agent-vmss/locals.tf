locals {
  resource_group_name                             = var.resource_group_name == "" ? "rg-${var.environment}-${var.location_short}-${var.name}" : var.resource_group_name
  keyvault_name                           = var.keyvault_name == "" ? join("-", compact(["kv-${var.environment}-${var.location_short}-${var.name}", var.unique_suffix])) : var.keyvault_name
  keyvault_resource_group_name                    = var.keyvault_resource_group_name == "" ? local.resource_group_name : var.keyvault_resource_group_name
  azure_pipelines_agent_image_resource_group_name = var.azure_pipelines_agent_image_resource_group_name == "" ? local.resource_group_name : var.azure_pipelines_agent_image_resource_group_name
}
