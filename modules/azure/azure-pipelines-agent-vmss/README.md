# Azure Pipelines Agent

This is the setup for Azure Pipelines Agent Virtual Machine Scale Set (VMSS).

## Azure DevOps Configuration

Follow this guide to setup the agent pool (manually): https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/scale-set-agents?view=azure-devops#create-the-scale-set-agent-pool

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.1.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/linux_virtual_machine_scale_set) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [azurerm_image.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/image) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_pipelines_agent_image_name"></a> [azure\_pipelines\_agent\_image\_name](#input\_azure\_pipelines\_agent\_image\_name) | The Azure Pipelines agent image name | `string` | n/a | yes |
| <a name="input_azure_pipelines_agent_image_resource_group_name"></a> [azure\_pipelines\_agent\_image\_resource\_group\_name](#input\_azure\_pipelines\_agent\_image\_resource\_group\_name) | The Azure Pipelines agent image resource group name | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name) | The keyvault name | `string` | `""` | no |
| <a name="input_keyvault_resource_group_name"></a> [keyvault\_resource\_group\_name](#input\_keyvault\_resource\_group\_name) | The keyvault resource group name | `string` | `""` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name | `string` | `""` | no |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | `""` | no |
| <a name="input_vmss_admin_username"></a> [vmss\_admin\_username](#input\_vmss\_admin\_username) | The admin username | `string` | `"azpagent"` | no |
| <a name="input_vmss_disk_size_gb"></a> [vmss\_disk\_size\_gb](#input\_vmss\_disk\_size\_gb) | The disk size (in GB) for the VMSS instances | `number` | `128` | no |
| <a name="input_vmss_instances"></a> [vmss\_instances](#input\_vmss\_instances) | The number of instances | `number` | `1` | no |
| <a name="input_vmss_sku"></a> [vmss\_sku](#input\_vmss\_sku) | The SKU for VMSS instances | `string` | `"Standard_F4s_v2"` | no |
| <a name="input_vmss_subnet_id"></a> [vmss\_subnet\_id](#input\_vmss\_subnet\_id) | The subnet id for the VMSS instances | `string` | n/a | yes |
| <a name="input_vmss_zones"></a> [vmss\_zones](#input\_vmss\_zones) | The zones to place the VMSS instances | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |

## Outputs

No outputs.
