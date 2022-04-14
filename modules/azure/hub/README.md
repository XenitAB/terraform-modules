# Hub

This module is used to create a separate network in one of the subscriptions (usually PROD) and connect it to all the networks.

## Usage

Use together with the `core` module to create a peered network where SPOF (single point of failure) resources can be created, lik Azure Pipelines Agent Virtual Machine Scale Set (VMSS).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.19.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.19.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_prefix_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/nat_gateway_public_ip_prefix_association) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/network_security_group) | resource |
| [azurerm_public_ip_prefix.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/public_ip_prefix) | resource |
| [azurerm_role_assignment.service_endpoint_join](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.service_endpoint_join](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/role_definition) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/virtual_network_peering) | resource |
| [azuread_group.service_endpoint_join](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/data-sources/group) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | Prefix for Azure AD Groups | `string` | `"az"` | no |
| <a name="input_azure_role_definition_prefix"></a> [azure\_role\_definition\_prefix](#input\_azure\_role\_definition\_prefix) | Prefix for Azure Role Definition names | `string` | `"role"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment (short name) to use for the deploy | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The location shortname for the subscription | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the deploy | `string` | n/a | yes |
| <a name="input_nat_gateway_public_ip_prefix_length"></a> [nat\_gateway\_public\_ip\_prefix\_length](#input\_nat\_gateway\_public\_ip\_prefix\_length) | The Public IP Prefix length for NAT Gateway | `number` | `31` | no |
| <a name="input_peering_config"></a> [peering\_config](#input\_peering\_config) | Peering configuration | <pre>list(object({<br>    name                         = string<br>    remote_virtual_network_id    = string<br>    allow_forwarded_traffic      = bool<br>    use_remote_gateways          = bool<br>    allow_virtual_network_access = bool<br>  }))</pre> | `[]` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The subscription CommonName to use for the deploy | `string` | n/a | yes |
| <a name="input_vnet_config"></a> [vnet\_config](#input\_vnet\_config) | Address spaces used by virtual network. | <pre>object({<br>    address_space = list(string)<br>    subnets = list(object({<br>      name              = string<br>      cidr              = string<br>      service_endpoints = list(string)<br>    }))<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip_prefixes"></a> [public\_ip\_prefixes](#output\_public\_ip\_prefixes) | Public IP prefix information |
| <a name="output_resource_groups"></a> [resource\_groups](#output\_resource\_groups) | Resource group information |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Subnet information |
| <a name="output_virtual_networks"></a> [virtual\_networks](#output\_virtual\_networks) | Virtual network information |
