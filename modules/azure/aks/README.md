# Azure Kubernetes Service

This module is used to create AKS clusters.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| azuread | 1.0.0 |
| azurerm | 2.35.0 |
| helm | 1.3.2 |
| kubernetes | 1.13.3 |
| random | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | 1.0.0 |
| azurerm | 2.35.0 |
| kubernetes | 1.13.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aad\_groups | Configuration for aad groups | <pre>object({<br>    view = map(any)<br>    edit = map(any)<br>    cluster_admin = object({<br>      id   = string<br>      name = string<br>    })<br>    cluster_view = object({<br>      id   = string<br>      name = string<br>    })<br>    aks_managed_identity = object({<br>      id   = string<br>      name = string<br>    })<br>  })</pre> | n/a | yes |
| aad\_pod\_identity | Configuration for aad pod identity | <pre>map(object({<br>    id        = string<br>    client_id = string<br>  }))</pre> | n/a | yes |
| aad\_pod\_identity\_enabled | Should aad-pod-identity be enabled | `bool` | `true` | no |
| acr\_name | Name of ACR registry to use for cluster | `string` | n/a | yes |
| aks\_authorized\_ips | Authorized IPs to access AKS API | `list(string)` | n/a | yes |
| aks\_config | The Azure Kubernetes Service (AKS) configuration | <pre>object({<br>    kubernetes_version = string<br>    sku_tier           = string<br>    default_node_pool = object({<br>      orchestrator_version = string<br>      vm_size              = string<br>      min_count            = number<br>      max_count            = number<br>      node_labels          = map(string)<br>    })<br>    additional_node_pools = list(object({<br>      name                 = string<br>      orchestrator_version = string<br>      vm_size              = string<br>      min_count            = number<br>      max_count            = number<br>      node_taints          = list(string)<br>      node_labels          = map(string)<br>    }))<br>  })</pre> | n/a | yes |
| aks\_name\_suffix | The suffix for the aks clusters | `number` | `1` | no |
| aks\_public\_ip\_prefix\_id | Public IP ID AKS egresses from | `string` | n/a | yes |
| azdo\_proxy\_enabled | Should azdo-proxy be enabled | `bool` | `true` | no |
| azure\_devops\_organization | Azure Devops organization used to configure azdo-proxy | `string` | `""` | no |
| cert\_manager\_enabled | Should Cert Manager be enabled | `bool` | `true` | no |
| core\_name | The commonName for the core infrastructure | `string` | n/a | yes |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| external\_dns\_enabled | Should External DNS be enabled | `bool` | `true` | no |
| external\_dns\_identity | External DNS identity information | <pre>object({<br>    client_id   = string<br>    resource_id = string<br>  })</pre> | n/a | yes |
| fluxcd\_v1\_enabled | Should fluxcd-v1 be enabled | `bool` | `true` | no |
| helm\_operator\_credentials | ACR credentials pased to Helm Operator | <pre>object({<br>    client_id = string<br>    secret    = string<br>  })</pre> | n/a | yes |
| helm\_operator\_enabled | Should helm-operator be enabled | `bool` | `true` | no |
| ingress\_nginx\_enabled | Should Ingress NGINX be enabled | `bool` | `true` | no |
| location\_short | The Azure region short name. | `string` | n/a | yes |
| name | The commonName to use for the deploy | `string` | n/a | yes |
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name                    = string<br>      delegate_resource_group = bool<br>      labels                  = map(string)<br>      flux = object({<br>        enabled      = bool<br>        azdo_org     = string<br>        azdo_project = string<br>        azdo_repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |
| opa\_gatekeeper\_enabled | Should OPA Gatekeeper be enabled | `bool` | `true` | no |
| ssh\_public\_key | SSH public key to add to servers | `string` | n/a | yes |
| velero | Velero configuration | <pre>object({<br>    azure_storage_account_name      = string<br>    azure_storage_account_container = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>    })<br>  })</pre> | n/a | yes |
| velero\_enabled | Should Velero be enabled | `bool` | `false` | no |

## Outputs

No output.

