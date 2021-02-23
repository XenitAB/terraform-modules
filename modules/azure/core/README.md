# Core

This module is used to create core resources like virtual network for the subscription.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| azuread | 1.4.0 |
| azurerm | 2.48.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | 1.4.0 |
| azurerm | 2.48.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_ad\_group\_prefix | Prefix for Azure AD Groupss | `string` | `"az"` | no |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| group\_name\_separator | Separator for group names | `string` | `"-"` | no |
| location\_short | The location shortname for the subscription | `string` | n/a | yes |
| name | The commonName to use for the deploy | `string` | n/a | yes |
| peering\_config | Peering configuration | <pre>list(object({<br>    name                         = string<br>    remote_virtual_network_id    = string<br>    allow_forwarded_traffic      = bool<br>    use_remote_gateways          = bool<br>    allow_virtual_network_access = bool<br>  }))</pre> | `[]` | no |
| subscription\_name | The subscriptionCommonName to use for the deploy | `string` | n/a | yes |
| vnet\_config | Address spaces used by virtual network. | <pre>object({<br>    address_space = list(string)<br>    subnets = list(object({<br>      name              = string<br>      cidr              = string<br>      service_endpoints = list(string)<br>      aks_subnet        = bool<br>    }))<br>  })</pre> | n/a | yes |

## Outputs

No output.

