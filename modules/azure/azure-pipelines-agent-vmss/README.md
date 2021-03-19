# Azure Pipelines Agent

This is the setup for Azure Pipelines Agent Virtual Machine Scale Set (VMSS).

## Azure DevOps Configuration

Follow this guide to setup the agent pool (manually): https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/scale-set-agents?view=azure-devops#create-the-scale-set-agent-pool

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| azurerm | 2.52.0 |
| tls | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 2.52.0 |
| tls | 3.1.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azurerm_image](https://registry.terraform.io/providers/hashicorp/azurerm/2.52.0/docs/data-sources/image) |
| [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/2.52.0/docs/data-sources/key_vault) |
| [azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/2.52.0/docs/resources/key_vault_secret) |
| [azurerm_linux_virtual_machine_scale_set](https://registry.terraform.io/providers/hashicorp/azurerm/2.52.0/docs/resources/linux_virtual_machine_scale_set) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.52.0/docs/data-sources/resource_group) |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.52.0/docs/data-sources/subnet) |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_pipelines\_agent\_image\_name | The Azure Pipelines agent image name | `string` | n/a | yes |
| azure\_pipelines\_agent\_image\_resource\_group\_name | The Azure Pipelines agent image resource group name | `string` | `""` | no |
| environment | The environment (short name) to use for the deploy | `string` | n/a | yes |
| keyvault\_name | The keyvault name | `string` | `""` | no |
| keyvault\_resource\_group\_name | The keyvault resource group name | `string` | `""` | no |
| location\_short | The location (short name) for the region | `string` | n/a | yes |
| name | The commonName to use for the deploy | `string` | n/a | yes |
| resource\_group\_name | The resource group name | `string` | `""` | no |
| unique\_suffix | Unique suffix that is used in globally unique resources names | `string` | `""` | no |
| vmss\_admin\_username | The admin username | `string` | `"azpagent"` | no |
| vmss\_disk\_size\_gb | The disk size (in GB) for the VMSS instances | `number` | `128` | no |
| vmss\_instances | The number of instances | `number` | `1` | no |
| vmss\_sku | The sku for VMSS instances | `string` | `"Standard_F4s_v2"` | no |
| vmss\_subnet\_config | The subnet configuration for the VMSS instances | <pre>object({<br>    name                 = string<br>    virtual_network_name = string<br>    resource_group_name  = string<br>  })</pre> | n/a | yes |
| vmss\_zones | The zones to place the VMSS instances | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |

## Outputs

No output.
