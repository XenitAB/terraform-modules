# Azure Kubernetes Service - Global

This module is used to create resources that are used by AKS clusters.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| azuread | 1.4.0 |
| azurerm | 2.51.0 |
| random | 3.1.0 |
| tls | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | 1.4.0 |
| azurerm | 2.51.0 |
| random | 3.1.0 |
| tls | 3.1.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/application) |
| [azuread_application_password](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/application_password) |
| [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/data-sources/group) |
| [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/group) |
| [azuread_group_member](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/group_member) |
| [azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/service_principal) |
| [azurerm_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/container_registry) |
| [azurerm_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/dns_zone) |
| [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/data-sources/key_vault) |
| [azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/key_vault_secret) |
| [azurerm_public_ip_prefix](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/public_ip_prefix) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/data-sources/resource_group) |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/role_assignment) |
| [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/storage_account) |
| [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/storage_container) |
| [azurerm_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/user_assigned_identity) |
| [random_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aks\_authorized\_ips | Authorized IPs to access AKS API | `list(string)` | n/a | yes |
| aks\_group\_name\_prefix | Prefix for AKS Azure AD groups | `string` | `"aks"` | no |
| azure\_ad\_group\_prefix | Prefix for Azure AD Groupss | `string` | `"az"` | no |
| core\_name | The name for the core infrastructure | `string` | n/a | yes |
| dns\_zone | The DNS Zone to create | `string` | n/a | yes |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| group\_name\_separator | Separator for group names | `string` | `"-"` | no |
| location\_short | The Azure region short name. | `string` | n/a | yes |
| name | The name to use for the deploy | `string` | n/a | yes |
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name                    = string<br>      delegate_resource_group = bool<br>    })<br>  )</pre> | n/a | yes |
| public\_ip\_prefix\_configuration | Configuration for public ip prefix | <pre>object({<br>    count         = number<br>    prefix_length = number<br>  })</pre> | <pre>{<br>  "count": 2,<br>  "prefix_length": 30<br>}</pre> | no |
| service\_principal\_name\_prefix | Prefix for service principals | `string` | `"sp"` | no |
| subscription\_name | The commonName for the subscription | `string` | n/a | yes |
| unique\_suffix | Unique suffix that is used in globally unique resources names | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| aad\_groups | Azure AD groups |
| aad\_pod\_identity | aad-pod-identity user assigned identities |
| acr\_name | Azure Container Registry Name |
| aks\_authorized\_ips | IP addresses authorized for API communication to Azure Kubernetes Service |
| aks\_public\_ip\_prefix\_ids | Azure Kubernetes Service IP Prefixes |
| dns\_zone | DNS Zone to be used with external-dns |
| external\_dns\_identity | MSI authentication identity for External DNS |
| helm\_operator\_credentials | Credentials meant to be used by Helm Operator |
| namespaces | Kubernetes namespaces |
| ssh\_public\_key | SSH public key to add to servers |
| velero | Velero configuration |
