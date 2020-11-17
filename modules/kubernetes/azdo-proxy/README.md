## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| azurerm | 2.35.0 |
| helm | 1.3.2 |
| kubernetes | 1.13.3 |
| random | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 2.35.0 |
| helm | 1.3.2 |
| kubernetes | 1.13.3 |
| random | 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azdo\_proxy\_config\_secret\_name | The name of the secret storing the azdo-proxy configuration | `string` | `"azdo-proxy-config"` | no |
| azdo\_proxy\_helm\_chart\_name | The helm chart name for azdo-proxy | `string` | `"azdo-proxy"` | no |
| azdo\_proxy\_helm\_chart\_version | The helm chart version for azdo-proxy | `string` | `"v0.3.0"` | no |
| azdo\_proxy\_helm\_repository | The helm repository for azdo-proxy | `string` | `"https://xenitab.github.io/azdo-proxy/"` | no |
| azdo\_proxy\_namespace | The namespace to be used by Azure DevOps Proxy | `string` | `"azdo-proxy"` | no |
| azure\_devops\_domain | The domain of Azure DevOps | `string` | `"dev.azure.com"` | no |
| azure\_devops\_organization | Azure Devops organization used to configure azdo-proxy | `string` | n/a | yes |
| azure\_devops\_pat | Azure DevOps PAT (Personal Access Token) | `string` | `""` | no |
| azure\_devops\_pat\_keyvault | Object to read Azure DevOps PAT (Personal Access Token) from Azure KeyVault | <pre>object({<br>    read_azure_devops_pat_from_azure_keyvault = bool<br>    azure_keyvault_id                         = string<br>    key                                       = string<br>  })</pre> | n/a | yes |
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled      = bool<br>        azdo_org     = string<br>        azdo_project = string<br>        azdo_repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| azdo\_proxy\_local\_passwords | The local passwords for Azure DevOps Proxy |

