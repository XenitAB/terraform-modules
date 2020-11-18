## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| azuread | 1.0.0 |
| azurerm | 2.35.0 |
| random | 3.0.0 |
| tls | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | 1.0.0 |
| azurerm | 2.35.0 |
| random | 3.0.0 |
| tls | 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aks\_authorized\_ips | Authorized IPs to access AKS API | `list(string)` | n/a | yes |
| core\_name | The name for the core infrastructure | `string` | n/a | yes |
| dns\_zone | The DNS Zone to create | `string` | n/a | yes |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| location\_short | The Azure region short name. | `string` | n/a | yes |
| name | The name to use for the deploy | `string` | n/a | yes |
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name                    = string<br>      delegate_resource_group = bool<br>      labels                  = map(string)<br>      flux = object({<br>        enabled      = bool<br>        azdo_org     = string<br>        azdo_project = string<br>        azdo_repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |
| public\_ip\_prefix\_configuration | Configuration for public ip prefix | <pre>object({<br>    count         = number<br>    prefix_length = number<br>  })</pre> | <pre>{<br>  "count": 2,<br>  "prefix_length": 30<br>}</pre> | no |
| subscription\_name | The commonName for the subscription | `string` | n/a | yes |

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

