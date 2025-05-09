## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.19.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/container_registry) | resource |
| [azurerm_container_registry_task.acr_purge_task](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/container_registry_task) | resource |
| [azurerm_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/dns_zone) | resource |
| [azurerm_management_lock.rg](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/management_lock) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.acr_push](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.acr_reader](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azuread_group.acr_pull](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azuread_group.acr_push](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azuread_group.acr_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_admin_enabled"></a> [acr\_admin\_enabled](#input\_acr\_admin\_enabled) | If ACR admin account should be enabled | `bool` | `false` | no |
| <a name="input_acr_name_override"></a> [acr\_name\_override](#input\_acr\_name\_override) | Override default name of ACR | `string` | `""` | no |
| <a name="input_aks_group_name_prefix"></a> [aks\_group\_name\_prefix](#input\_aks\_group\_name\_prefix) | Prefix for AKS Azure AD groups | `string` | `"aks"` | no |
| <a name="input_aks_managed_identity"></a> [aks\_managed\_identity](#input\_aks\_managed\_identity) | AKS Azure AD managed identity | `string` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | List of DNS Zone to create | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environemnt | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_lock_resource_group"></a> [lock\_resource\_group](#input\_lock\_resource\_group) | Lock the resource group for deletion | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the deploy | `string` | n/a | yes |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | n/a | yes |

## Outputs

No outputs.
