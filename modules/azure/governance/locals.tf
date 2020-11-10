locals {
  env_resources = { for p in setproduct(var.resource_group_configs, var.regions) : "${var.environment}-${p[1].locationShort}-${p[0].common_name}" => {
    name             = "${var.environment}-${p[1].locationShort}-${p[0].common_name}"
    environment = var.environment
    resource_group_config         = p[0]
    region           = p[1]
    }
  }
  coreRgs            = [for region in var.regions : "${var.environment}-${region.locationShort}-${var.core_name}"]
  groupNameSeparator = "-"
  aadGroupPrefix     = "az"
  spNamePrefix       = "sp"
  aksGroupNamePrefix = "aks"
}
