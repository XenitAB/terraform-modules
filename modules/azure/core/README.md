# Core

This module is used to create core resources like virtual network for the subscription.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.14.7 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 1.4.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.55.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 1.4.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/network_security_group) | resource |
| [azurerm_role_assignment.service_endpoint_join](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.service_endpoint_join](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/role_definition) | resource |
| [azurerm_route.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/route) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/route_table) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/storage_account) | resource |
| [azurerm_subnet.aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/subnet) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/resources/virtual_network_peering) | resource |
| [azuread_group.service_endpoint_join](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/data-sources/group) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.55.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | Prefix for Azure AD Groupss | `string` | `"az"` | no |
| <a name="input_enable_storage_account"></a> [enable\_storage\_account](#input\_enable\_storage\_account) | Should a storage account be created in the core resource group? (used for diagnostics) | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The location shortname for the subscription | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_peering_config"></a> [peering\_config](#input\_peering\_config) | Peering configuration | <pre>list(object({<br>    name                         = string<br>    remote_virtual_network_id    = string<br>    allow_forwarded_traffic      = bool<br>    use_remote_gateways          = bool<br>    allow_virtual_network_access = bool<br>  }))</pre> | `[]` | no |
| <a name="input_route_config"></a> [route\_config](#input\_route\_config) | Route configuration. Not applied to aks subnets. | <pre>list(object({<br>    subnet_name = string # Short name for the subnet<br>    routes = list(object({<br>      name                   = string # Name of the route<br>      address_prefix         = string # Example: 192.168.0.0/24<br>      next_hop_type          = string # VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None<br>      next_hop_in_ip_address = string # Only set if next_hop_type is VirtualAppliance<br>    }))<br><br>  }))</pre> | `[]` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The subscriptionCommonName to use for the deploy | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | `""` | no |
| <a name="input_vnet_config"></a> [vnet\_config](#input\_vnet\_config) | Address spaces used by virtual network. | <pre>object({<br>    address_space = list(string)<br>    dns_servers   = list(string)<br>    subnets = list(object({<br>      name              = string<br>      cidr              = string<br>      service_endpoints = list(string)<br>      aks_subnet        = bool<br>    }))<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
