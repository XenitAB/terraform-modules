# Core

This module is used to create core resources like virtual network for the subscription.
This module assumes that you have a RG called `rg-<env>-<location_short>-log`.
Easiest is to define this RG in the governance module.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | 2.0.0-preview3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 2.0.0-preview3 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_names"></a> [names](#module\_names) | ../names | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_action_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_metric_alert.log](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/monitor_metric_alert) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/network_security_group) | resource |
| [azurerm_role_assignment.service_endpoint_join](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.service_endpoint_join](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_definition) | resource |
| [azurerm_route.not_virtual_appliance](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/route) | resource |
| [azurerm_route.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/route) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/route_table) | resource |
| [azurerm_storage_account.log](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/storage_account) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/storage_account) | resource |
| [azurerm_subnet.aks](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/subnet) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/virtual_network_peering) | resource |
| [azuread_group.service_endpoint_join](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azurecaf_name.azuread_group_service_endpoint_join](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azurerm_monitor_action_group_this](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azurerm_network_security_group_this](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azurerm_resource_group_log](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azurerm_resource_group_this](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azurerm_role_definition_service_endpoint_join](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azurerm_route_table_this](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azurerm_storage_account_log](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azurerm_storage_account_this](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azurerm_virtual_network_this](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.local_peerings_name](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.local_subnets_subnet_full_name](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurerm_resource_group.log](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alerts_enabled"></a> [alerts\_enabled](#input\_alerts\_enabled) | Should alert rules be created by default | `bool` | `false` | no |
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | Prefix for Azure AD Groups | `string` | `"az"` | no |
| <a name="input_azure_role_definition_prefix"></a> [azure\_role\_definition\_prefix](#input\_azure\_role\_definition\_prefix) | Prefix for Azure Role Definition names | `string` | `"role"` | no |
| <a name="input_enable_storage_account"></a> [enable\_storage\_account](#input\_enable\_storage\_account) | Should a storage account be created in the core resource group? (used for diagnostics) | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_log_common_name"></a> [log\_common\_name](#input\_log\_common\_name) | The common name for the logs | `string` | `"log"` | no |
| <a name="input_name"></a> [name](#input\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address to send alert notifications | `string` | n/a | yes |
| <a name="input_peering_config"></a> [peering\_config](#input\_peering\_config) | Network peering configuration | <pre>list(object({<br/>    name                         = string<br/>    remote_virtual_network_id    = string<br/>    allow_forwarded_traffic      = bool<br/>    use_remote_gateways          = bool<br/>    allow_virtual_network_access = bool<br/>    allow_gateway_transit        = optional(bool, false) # Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network.<br/>  }))</pre> | `[]` | no |
| <a name="input_resource_name_overrides"></a> [resource\_name\_overrides](#input\_resource\_name\_overrides) | A way to override the resource names | `any` | `null` | no |
| <a name="input_route_config"></a> [route\_config](#input\_route\_config) | Route configuration. Not applied to AKS subnets | <pre>list(object({<br/>    subnet_name                   = string                # Short name for the subnet<br/>    disable_bgp_route_propagation = optional(bool, false) # Controls propagation of routes learned by BGP on that route table<br/>    routes = list(object({<br/>      name                   = string # Name of the route<br/>      address_prefix         = string # Example: 192.168.0.0/24<br/>      next_hop_type          = string # VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None<br/>      next_hop_in_ip_address = string # Only set if next_hop_type is VirtualAppliance<br/>    }))<br/><br/>  }))</pre> | `[]` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The subscription commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | n/a | yes |
| <a name="input_vnet_config"></a> [vnet\_config](#input\_vnet\_config) | Address spaces used by virtual network | <pre>object({<br/>    address_space = list(string)<br/>    dns_servers   = list(string)<br/>    subnets = list(object({<br/>      name              = string<br/>      cidr              = string<br/>      service_endpoints = list(string)<br/>      create_nsg        = bool<br/>    }))<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_security_groups"></a> [network\_security\_groups](#output\_network\_security\_groups) | Output for Azure Network Security Groups |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | Output for Azure Routing Tables |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Output for Azure Virtual Network Subnets |
| <a name="output_virtual_network"></a> [virtual\_network](#output\_virtual\_network) | Output for Azure Virtual Network |
