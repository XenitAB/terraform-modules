locals {
  resource_group_name                     = var.resource_group_name == "" ? "rg-${var.environment}-${var.location_short}-${var.name}" : var.resource_group_name
  keyvault_name                           = var.keyvault_name == "" ? join("-", compact(["kv-${var.environment}-${var.location_short}-${var.name}", var.unique_suffix])) : var.keyvault_name
  keyvault_resource_group_name            = var.keyvault_resource_group_name == "" ? local.resource_group_name : var.keyvault_resource_group_name
  github_runner_image_resource_group_name = var.github_runner_image_resource_group_name == "" ? local.resource_group_name : var.github_runner_image_resource_group_name
  custom_data                             = templatefile("${path.module}/templates/cloud-init.tpl", { azure_keyvault_name = local.keyvault_name, github_organization_kvsecret = var.github_organization_kvsecret, github_app_id_kvsecret = var.github_app_id_kvsecret, github_installation_id_kvsecret = var.github_installation_id_kvsecret, github_private_key_kvsecret = var.github_private_key_kvsecret })
}
