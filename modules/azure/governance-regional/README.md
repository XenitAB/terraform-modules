# Governance

DEPRECATED: Use `governance-global` and `governance-regional` instead.

This module is used to create resource groups, service principals, Azure AD groups, Azure KeyVaults and delegation to all of those resources.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| azuread | 1.4.0 |
| azurerm | 2.48.0 |
| pal | 0.2.4 |
| random | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | 1.4.0 |
| azurerm | 2.48.0 |
| pal | 0.2.4 |
| random | 3.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aks\_group\_name\_prefix | Prefix for AKS Azure AD groups | `string` | `"aks"` | no |
| azure\_ad\_group\_prefix | Prefix for Azure AD Groupss | `string` | `"az"` | no |
| core\_name | The commonName for the core infra | `string` | n/a | yes |
| delegate\_acr | Should Azure Container Registry delegation be configured? | `bool` | `true` | no |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| group\_name\_separator | Separator for group names | `string` | `"-"` | no |
| location | The location for the subscription | `string` | n/a | yes |
| location\_short | The location shortname for the subscription | `string` | n/a | yes |
| owner\_service\_principal\_name | The name of the service principal that will be used to run terraform and is owner of the subsciptions | `string` | n/a | yes |
| partner\_id | Azure partner id to link service principal with | `string` | `""` | no |
| resource\_group\_configs | Resource group configuration | <pre>list(<br>    object({<br>      common_name                = string<br>      delegate_aks               = bool # Delegate aks permissions<br>      delegate_key_vault         = bool # Delegate KeyVault creation<br>      delegate_service_endpoint  = bool # Delegate Service Endpoint permissions<br>      delegate_service_principal = bool # Delegate Service Principal<br>      tags                       = map(string)<br>    })<br>  )</pre> | n/a | yes |
| service\_principal\_name\_prefix | Prefix for service principals | `string` | `"sp"` | no |
| subscription\_name | The commonName for the subscription | `string` | n/a | yes |
| unique\_suffix | Unique suffix that is used in globally unique resources names | `string` | `""` | no |

## Outputs

No output.

