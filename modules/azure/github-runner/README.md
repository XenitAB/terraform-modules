# GitHub Actions Self-hosted Runner

This is the setup for GitHub Actions Self-hosted Runner Virtual Machine Scale Set (VMSS).

## GitHub Runner Configuration

Setup a GitHub App according to the documentation for [XenitAB/github-runner](https://github.com/XenitAB/github-runner).

Setup an image using Packer according [github-runner](https://github.com/XenitAB/packer-templates/tree/main/templates/azure/github-runner) in [XenitAB/packer-templates](https://github.com/XenitAB/packer-templates).

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
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/linux_virtual_machine_scale_set) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [azurerm_image.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/image) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.github_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/subnet) | data source |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_github_app_id_kvsecret"></a> [github\_app\_id\_kvsecret](#input\_github\_app\_id\_kvsecret) | The Azure KeyVault Secret containing the GitHub App ID | `string` | `"github-app-id"` | no |
| <a name="input_github_installation_id_kvsecret"></a> [github\_installation\_id\_kvsecret](#input\_github\_installation\_id\_kvsecret) | The Azure KeyVault Secret containing the GitHub App Installation ID | `string` | `"github-installation-id"` | no |
| <a name="input_github_organization_kvsecret"></a> [github\_organization\_kvsecret](#input\_github\_organization\_kvsecret) | The Azure KeyVault Secret containing the GitHub Organization name | `string` | `"github-organization"` | no |
| <a name="input_github_private_key_kvsecret"></a> [github\_private\_key\_kvsecret](#input\_github\_private\_key\_kvsecret) | The AzureKey Vault Secret containing the GitHub App Private Key | `string` | `"github-private-key"` | no |
| <a name="input_github_runner_image_name"></a> [github\_runner\_image\_name](#input\_github\_runner\_image\_name) | The Azure Pipelines agent image name | `string` | n/a | yes |
| <a name="input_github_runner_image_resource_group_name"></a> [github\_runner\_image\_resource\_group\_name](#input\_github\_runner\_image\_resource\_group\_name) | The Azure Pipelines agent image resource group name | `string` | `""` | no |
| <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name) | The keyvault name | `string` | `""` | no |
| <a name="input_keyvault_resource_group_name"></a> [keyvault\_resource\_group\_name](#input\_keyvault\_resource\_group\_name) | The keyvault resource group name | `string` | `""` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name | `string` | `""` | no |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | `""` | no |
| <a name="input_vmss_admin_username"></a> [vmss\_admin\_username](#input\_vmss\_admin\_username) | The admin username | `string` | `"ghradmin"` | no |
| <a name="input_vmss_disk_size_gb"></a> [vmss\_disk\_size\_gb](#input\_vmss\_disk\_size\_gb) | The disk size (in GB) for the VMSS instances | `number` | `128` | no |
| <a name="input_vmss_instances"></a> [vmss\_instances](#input\_vmss\_instances) | The number of instances | `number` | `1` | no |
| <a name="input_vmss_sku"></a> [vmss\_sku](#input\_vmss\_sku) | The sku for VMSS instances | `string` | `"Standard_F4s_v2"` | no |
| <a name="input_vmss_subnet_config"></a> [vmss\_subnet\_config](#input\_vmss\_subnet\_config) | The subnet configuration for the VMSS instances | <pre>object({<br>    name                 = string<br>    virtual_network_name = string<br>    resource_group_name  = string<br>  })</pre> | n/a | yes |
| <a name="input_vmss_zones"></a> [vmss\_zones](#input\_vmss\_zones) | The zones to place the VMSS instances | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |

## Outputs

No outputs.
