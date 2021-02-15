# GitHub Actions Self-hosted Runner

This is the setup for GitHub Actions Self-hosted Runner Virtual Machine Scale Set (VMSS).

## GitHub Runner Configuration

Setup a GitHub App according to the documentation for [XenitAB/github-runner](https://github.com/XenitAB/github-runner).

Setup an image using Packer according [github-runner](https://github.com/XenitAB/packer-templates/tree/main/templates/azure/github-runner) in [XenitAB/packer-templates](https://github.com/XenitAB/packer-templates).

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| azurerm | 2.47.0 |
| tls | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 2.47.0 |
| tls | 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environment (short name) to use for the deploy | `string` | n/a | yes |
| github\_app\_id\_kvsecret | The Azure KeyVault Secret containing the GitHub App ID | `string` | `"github-app-id"` | no |
| github\_installation\_id\_kvsecret | The Azure KeyVault Secret containing the GitHub App Installation ID | `string` | `"github-installation-id"` | no |
| github\_organization\_kvsecret | The Azure KeyVault Secret containing the GitHub Organization name | `string` | `"github-organization"` | no |
| github\_private\_key\_kvsecret | The Azure KeyVault Secret containing the GitHub App Private Key | `string` | `"github-private-key"` | no |
| github\_runner\_image\_name | The Azure Pipelines agent image name | `string` | n/a | yes |
| github\_runner\_image\_resource\_group\_name | The Azure Pipelines agent image resource group name | `string` | `""` | no |
| keyvault\_name | The keyvault name | `string` | `""` | no |
| keyvault\_resource\_group\_name | The keyvault resource group name | `string` | `""` | no |
| location\_short | The location (short name) for the region | `string` | n/a | yes |
| name | The commonName to use for the deploy | `string` | n/a | yes |
| resource\_group\_name | The resource group name | `string` | `""` | no |
| unique\_suffix | Unique suffix that is used in globally unique resources names | `string` | `""` | no |
| vmss\_admin\_username | The admin username | `string` | `"ghradmin"` | no |
| vmss\_disk\_size\_gb | The disk size (in GB) for the VMSS instances | `number` | `128` | no |
| vmss\_instances | The number of instances | `number` | `1` | no |
| vmss\_sku | The sku for VMSS instances | `string` | `"Standard_F4s_v2"` | no |
| vmss\_subnet\_config | The subnet configuration for the VMSS instances | <pre>object({<br>    name                 = string<br>    virtual_network_name = string<br>    resource_group_name  = string<br>  })</pre> | n/a | yes |
| vmss\_zones | The zones to place the VMSS instances | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |

## Outputs

No output.

