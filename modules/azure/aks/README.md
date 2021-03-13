# Azure Kubernetes Service

This module is used to create AKS clusters.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| azuread | 1.4.0 |
| azurerm | 2.51.0 |
| random | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | 1.4.0 |
| azurerm | 2.51.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azuread_group_member](https://registry.terraform.io/providers/hashicorp/azuread/1.4.0/docs/resources/group_member) |
| [azurerm_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/kubernetes_cluster) |
| [azurerm_kubernetes_cluster_node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/kubernetes_cluster_node_pool) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/data-sources/resource_group) |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/resources/role_assignment) |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.51.0/docs/data-sources/subnet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aad\_groups | Configuration for aad groups | <pre>object({<br>    view = map(any)<br>    edit = map(any)<br>    cluster_admin = object({<br>      id   = string<br>      name = string<br>    })<br>    cluster_view = object({<br>      id   = string<br>      name = string<br>    })<br>    aks_managed_identity = object({<br>      id   = string<br>      name = string<br>    })<br>  })</pre> | n/a | yes |
| aks\_authorized\_ips | Authorized IPs to access AKS API | `list(string)` | n/a | yes |
| aks\_config | The Azure Kubernetes Service (AKS) configuration | <pre>object({<br>    kubernetes_version = string<br>    sku_tier           = string<br>    default_node_pool = object({<br>      orchestrator_version = string<br>      vm_size              = string<br>      min_count            = number<br>      max_count            = number<br>      node_labels          = map(string)<br>    })<br>    additional_node_pools = list(object({<br>      name                 = string<br>      orchestrator_version = string<br>      vm_size              = string<br>      min_count            = number<br>      max_count            = number<br>      node_taints          = list(string)<br>      node_labels          = map(string)<br>    }))<br>  })</pre> | n/a | yes |
| aks\_name\_suffix | The suffix for the aks clusters | `number` | `1` | no |
| aks\_public\_ip\_prefix\_id | Public IP ID AKS egresses from | `string` | n/a | yes |
| core\_name | The commonName for the core infrastructure | `string` | n/a | yes |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| location\_short | The Azure region short name. | `string` | n/a | yes |
| name | The commonName to use for the deploy | `string` | n/a | yes |
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name                    = string<br>      delegate_resource_group = bool<br>    })<br>  )</pre> | n/a | yes |
| ssh\_public\_key | SSH public key to add to servers | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| kube\_config | Kube config for the created AKS cluster |
