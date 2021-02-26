# Governance

DEPRECATED: Use `governance-global` and `governance-regional` instead.

This module is used to create resource groups, service principals, Azure AD groups, Azure KeyVaults and delegation to all of those resources.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| azuread | 1.3.0 |
| azurerm | 2.47.0 |
| pal | 0.2.4 |
| random | 3.0.1 |

## Providers

| Name | Version |
|------|---------|
| azuread | 1.3.0 |
| azurerm | 2.47.0 |
| pal | 0.2.4 |
| random | 3.0.1 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/1.3.0/docs/data-sources/application) |
| [azuread_application_password](https://registry.terraform.io/providers/hashicorp/azuread/1.3.0/docs/resources/application_password) |
| [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/1.3.0/docs/data-sources/group) |
| [azuread_group_member](https://registry.terraform.io/providers/hashicorp/azuread/1.3.0/docs/resources/group_member) |
| [azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/1.3.0/docs/data-sources/service_principal) |
| [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/data-sources/client_config) |
| [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/key_vault) |
| [azurerm_key_vault_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/key_vault_secret) |
| [azurerm_management_lock](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/management_lock) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/resource_group) |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/role_assignment) |
| [azurerm_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/data-sources/subscription) |
| [pal_management_partner](https://registry.terraform.io/providers/xenitab/pal/0.2.4/docs/resources/management_partner) |
| [random_password](https://registry.terraform.io/providers/hashicorp/random/3.0.1/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aks\_group\_name\_prefix | Prefix for AKS Azure AD groups | `string` | `"aks"` | no |
| azure\_ad\_group\_prefix | Prefix for Azure AD Groupss | `string` | `"az"` | no |
| core\_name | The commonName for the core infra | `string` | n/a | yes |
| delegate\_acr | Should Azure Container Registry delegation be configured? | `bool` | `true` | no |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| group\_name\_separator | Separator for group names | `string` | `"-"` | no |
| location | The location for the subscription | `string` | n/a | yes |
| location\_short | The location shortname for the subscription | `string` | n/a | yes |
| owner\_service\_principal\_name | The name of the service principal that will be used to run terraform and is owner of the subsciptions | `string` | n/a | yes |
| partner\_id | Azure partner id to link service principal with | `string` | `""` | no |
| resource\_group\_configs | Resource group configuration | <pre>list(<br>    object({<br>      common_name                = string<br>      delegate_aks               = bool # Delegate aks permissions<br>      delegate_key_vault         = bool # Delegate KeyVault creation<br>      delegate_service_endpoint  = bool # Delegate Service Endpoint permissions<br>      delegate_service_principal = bool # Delegate Service Principal<br>      lock_resource_group        = bool # Adds management_lock (CanNotDelete) to the resource group<br>      tags                       = map(string)<br>    })<br>  )</pre> | n/a | yes |
| service\_principal\_name\_prefix | Prefix for service principals | `string` | `"sp"` | no |
| subscription\_name | The commonName for the subscription | `string` | n/a | yes |
| unique\_suffix | Unique suffix that is used in globally unique resources names | `string` | `""` | no |

## Outputs

No output.
