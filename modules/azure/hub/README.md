# Hub

This module is used to create a separate network in one of the subscriptions (usually PROD) and connect it to all the networks.

## Usage

Use together with the `core` module to create a peered network where SPOF (single point of failure) resources can be created, lik Azure Pipelines Agent Virtual Machine Scale Set (VMSS).

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
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
| [azurerm_nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/nat_gateway) |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/network_security_group) |
| [azurerm_public_ip_prefix](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/public_ip_prefix) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/data-sources/resource_group) |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/role_assignment) |
| [azurerm_role_definition](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/role_definition) |
| [azurerm_subnet_nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/subnet_nat_gateway_association) |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/subnet_network_security_group_association) |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/subnet) |
| [azurerm_virtual_network_peering](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/virtual_network_peering) |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/2.47.0/docs/resources/virtual_network) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_ad\_group\_prefix | Prefix for Azure AD Groupss | `string` | `"az"` | no |
| environment | The environment (short name) to use for the deploy | `string` | n/a | yes |
| group\_name\_separator | Separator for group names | `string` | `"-"` | no |
| name | The name to use for the deploy | `string` | n/a | yes |
| nat\_gateway\_public\_ip\_prefix\_length | The Public IP Prefix length for NAT Gateway | `number` | `31` | no |
| peering\_config | Peering configuration | <pre>map(list(object({<br>    name                         = string<br>    remote_virtual_network_id    = string<br>    allow_forwarded_traffic      = bool<br>    use_remote_gateways          = bool<br>    allow_virtual_network_access = bool<br>  })))</pre> | `{}` | no |
| regions | The Azure Regions to configure | <pre>list(object({<br>    location       = string<br>    location_short = string<br>  }))</pre> | n/a | yes |
| subscription\_name | The subscriptionCommonName to use for the deploy | `string` | n/a | yes |
| vnet\_config | Address spaces used by virtual network. | <pre>map(object({<br>    address_space = list(string)<br>    subnets = list(object({<br>      name              = string<br>      cidr              = string<br>      service_endpoints = list(string)<br>    }))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| public\_ip\_prefixes | Public IP prefix information |
| resource\_groups | Resource group information |
| subnets | Subnet information |
| virtual\_networks | Virtual network information |
