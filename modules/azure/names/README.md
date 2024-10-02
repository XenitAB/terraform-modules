# Azure naming conventions

This module is created to be used together with the [`aztfmod/azurecaf`](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs) provider.

Load the module:

```terraform
module "names" {
  source = "../names"

  resource_name_overrides = var.resource_name_overrides
  environment             = var.environment
  location_short          = var.location_short
  unique_suffix           = var.unique_suffix
}
```

Then it can be used like this:

```terraform
data "azurecaf_name" "azurerm_resource_group_rg" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  name          = each.value.common_name
  resource_type = "azurerm_resource_group"
  prefixes      = module.names.this.azurerm_resource_group.prefixes
  suffixes      = module.names.this.azurerm_resource_group.suffixes
  use_slug      = false
}
```

Then you use it with a resource:

```terraform
resource "azurerm_resource_group" "rg" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  name     = data.azurecaf_name.azurerm_resource_group_rg[each.key].result
  location = var.location
  tags = merge(
    {
      "Environment"   = var.environment,
      "LocationShort" = var.location_short
    },
    each.value.tags
  )
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_group_name_prefix"></a> [aks\_group\_name\_prefix](#input\_aks\_group\_name\_prefix) | Prefix for AKS Azure AD groups | `string` | `"aks"` | no |
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | Prefix for Azure AD Groups | `string` | `"az"` | no |
| <a name="input_azure_role_definition_prefix"></a> [azure\_role\_definition\_prefix](#input\_azure\_role\_definition\_prefix) | Prefix for Azure Role Definition names | `string` | `"role"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | `null` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The location shortname for the subscription | `string` | `null` | no |
| <a name="input_resource_name_overrides"></a> [resource\_name\_overrides](#input\_resource\_name\_overrides) | A way to override the resource names | <pre>object({<br/>    azuread_group_rg = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azuread_group_sub = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azuread_group_all_subs = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azuread_group_acr = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azuread_application_rg = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azuread_application_sub = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_resource_group = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_key_vault = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_monitor_action_group = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_role_definition = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_storage_account_log = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_virtual_network = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_network_security_group = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_route_table = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_subnet = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_virtual_network_peering = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>    azurerm_storage_account = optional(object({<br/>      prefixes = optional(list(string))<br/>      suffixes = optional(list(string))<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_service_principal_name_prefix"></a> [service\_principal\_name\_prefix](#input\_service\_principal\_name\_prefix) | Prefix for service principals | `string` | `"sp"` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | `null` | no |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this"></a> [this](#output\_this) | resource name configurations to be used with azurecaf\_name |
