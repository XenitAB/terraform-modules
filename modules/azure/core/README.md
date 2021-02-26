# Core

This module is used to create core resources like virtual network for the subscription.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| azuread | 1.3.0 |
| azurerm | 2.47.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | 1.3.0 |
| azurerm | 2.47.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/1.3.0/docs/data-sources/group) |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/network_security_group) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/data-sources/resource_group) |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/role_assignment) |
| [azurerm_role_definition](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/role_definition) |
| [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/storage_account) |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/subnet) |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/subnet_network_security_group_association) |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/virtual_network) |
| [azurerm_virtual_network_peering](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/virtual_network_peering) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_ad\_group\_prefix | Prefix for Azure AD Groupss | `string` | `"az"` | no |
| enable\_storage\_account | Should a storage account be created in the core resource group? (used for diagnostics) | `bool` | `false` | no |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| group\_name\_separator | Separator for group names | `string` | `"-"` | no |
| location\_short | The location shortname for the subscription | `string` | n/a | yes |
| name | The commonName to use for the deploy | `string` | n/a | yes |
| peering\_config | Peering configuration | <pre>list(object({<br>    name                         = string<br>    remote_virtual_network_id    = string<br>    allow_forwarded_traffic      = bool<br>    use_remote_gateways          = bool<br>    allow_virtual_network_access = bool<br>  }))</pre> | `[]` | no |
| subscription\_name | The subscriptionCommonName to use for the deploy | `string` | n/a | yes |
| unique\_suffix | Unique suffix that is used in globally unique resources names | `string` | `""` | no |
| vnet\_config | Address spaces used by virtual network. | <pre>object({<br>    address_space = list(string)<br>    subnets = list(object({<br>      name              = string<br>      cidr              = string<br>      service_endpoints = list(string)<br>      aks_subnet        = bool<br>    }))<br>  })</pre> | n/a | yes |

## Outputs

No output.
