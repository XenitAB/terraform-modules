# Governance (Deprecated)

DEPRECATED: Use `governance-global` and `governance-regional` instead.

This module is used to create resource groups, service principals, Azure AD groups, Azure KeyVaults and delegation to all of those resources.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| azuread | 1.4.0 |
| azurerm | 2.50.0 |
| pal | 0.2.4 |
| random | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | 1.4.0 |
| azurerm | 2.50.0 |
| pal | 0.2.4 |
| random | 3.1.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/data-sources/application) |
| [azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/application) |
| [azuread_application_password](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/application_password) |
| [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/data-sources/group) |
| [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/group) |
| [azuread_group_member](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/group_member) |
| [azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/data-sources/service_principal) |
| [azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/service_principal) |
| [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/2.50.0/docs/data-sources/client_config) |
| [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/2.50.0/docs/resources/key_vault) |
| [azurerm_key_vault_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.50.0/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/2.50.0/docs/resources/key_vault_secret) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.50.0/docs/resources/resource_group) |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.50.0/docs/resources/role_assignment) |
| [azurerm_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/2.50.0/docs/data-sources/subscription) |
| [pal_management_partner](https://registry.terraform.io/providers/xenitab/pal/0.2.4/docs/resources/management_partner) |
| [random_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accept\_deprecation | This variable is used to make sure those using it gets a notification. Not used for anything, but requires you to set it to something. | `string` | n/a | yes |
| aks\_group\_name\_prefix | Prefix for AKS Azure AD groups | `string` | `"aks"` | no |
| azure\_ad\_group\_prefix | Prefix for Azure AD Groupss | `string` | `"az"` | no |
| core\_name | The commonName for the core infra | `string` | n/a | yes |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| group\_name\_separator | Separator for group names | `string` | `"-"` | no |
| owner\_service\_principal\_name | The name of the service principal that will be used to run terraform and is owner of the subsciptions | `string` | n/a | yes |
| partner\_id | Azure partner id to link service principal with | `string` | `""` | no |
| regions | The Azure Regions to configure | <pre>list(object({<br>    location       = string<br>    location_short = string<br>  }))</pre> | n/a | yes |
| resource\_group\_configs | Resource group configuration | <pre>list(<br>    object({<br>      common_name                = string<br>      delegate_aks               = bool # Delegate aks permissions<br>      delegate_key_vault         = bool # Delegate KeyVault creation<br>      delegate_service_endpoint  = bool # Delegate Service Endpoint permissions<br>      delegate_service_principal = bool # Delegate Service Principal<br>      tags                       = map(string)<br>    })<br>  )</pre> | n/a | yes |
| service\_principal\_name\_prefix | Prefix for service principals | `string` | `"sp"` | no |
| subscription\_name | The commonName for the subscription | `string` | n/a | yes |
| unique\_suffix | Unique suffix that is used in globally unique resources names | `string` | `""` | no |

## Outputs

No output.
