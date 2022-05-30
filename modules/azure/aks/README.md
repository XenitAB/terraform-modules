# Azure Kubernetes Service

This module is used to create AKS clusters.
The cluster is configured with a system pool that currently has a single node. The node is tainted
so that only kube-system pods can run on that system pool. This is partially to protect the system
critical pods from user applications and simplify scaling.
https://docs.microsoft.com/en-us/azure/aks/use-system-pools#system-and-user-node-pools

Refer to the following docs for steps to replace the system node pool without recreating the cluster.
https://pumpingco.de/blog/modify-aks-default-node-pool-in-terraform-without-redeploying-the-cluster/

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.19.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.8.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.19.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_group_member.aks_managed_identity](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group_member) | resource |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_role_assignment.aks_managed_identity_noderg_managed_identity_operator](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_managed_identity_noderg_virtual_machine_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.azure_metrics](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.azure_metrics_aks_reader](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.azure_metrics_lb_reader](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cluster_admin](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cluster_view](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.edit](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.view](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.azure_metrics](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_groups"></a> [aad\_groups](#input\_aad\_groups) | Configuration for Azure AD Groups (AAD Groups) | <pre>object({<br>    view = map(any)<br>    edit = map(any)<br>    cluster_admin = object({<br>      id   = string<br>      name = string<br>    })<br>    cluster_view = object({<br>      id   = string<br>      name = string<br>    })<br>    aks_managed_identity = object({<br>      id   = string<br>      name = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_aks_authorized_ips"></a> [aks\_authorized\_ips](#input\_aks\_authorized\_ips) | Authorized IPs to access AKS API | `list(string)` | n/a | yes |
| <a name="input_aks_config"></a> [aks\_config](#input\_aks\_config) | The Azure Kubernetes Service (AKS) configuration | <pre>object({<br>    version = string<br>    # Enables paid SKU for AKS and makes the default node pool HA<br>    production_grade = bool<br>    node_pools = list(object({<br>      name           = string<br>      version        = string<br>      vm_size        = string<br>      min_count      = number<br>      max_count      = number<br>      spot_enabled   = bool<br>      spot_max_price = number<br>      node_taints    = list(string)<br>      node_labels    = map(string)<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_aks_default_node_pool_vm_size"></a> [aks\_default\_node\_pool\_vm\_size](#input\_aks\_default\_node\_pool\_vm\_size) | The VM size of the AKS clusters default node pool. Do not override unless explicitly required. | `string` | `"Standard_D2ds_v5"` | no |
| <a name="input_aks_log_analytics_id"></a> [aks\_log\_analytics\_id](#input\_aks\_log\_analytics\_id) | The log analytics workspace id where to store the AKS resource logs | `string` | n/a | yes |
| <a name="input_aks_managed_identity_group_id"></a> [aks\_managed\_identity\_group\_id](#input\_aks\_managed\_identity\_group\_id) | The group id of aks managed identity | `string` | n/a | yes |
| <a name="input_aks_name_suffix"></a> [aks\_name\_suffix](#input\_aks\_name\_suffix) | The suffix for the Azure Kubernetes Service (AKS) clusters | `number` | n/a | yes |
| <a name="input_aks_public_ip_prefix_id"></a> [aks\_public\_ip\_prefix\_id](#input\_aks\_public\_ip\_prefix\_id) | Public IP ID AKS egresses from | `string` | n/a | yes |
| <a name="input_core_name"></a> [core\_name](#input\_core\_name) | The commonName for the core infrastructure | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes | <pre>list(<br>    object({<br>      name                    = string<br>      delegate_resource_group = bool<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key to add to servers | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_metrics_identity"></a> [azure\_metrics\_identity](#output\_azure\_metrics\_identity) | MSI authentication identity for Azure Metrics |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Kube config for the created AKS cluster |
