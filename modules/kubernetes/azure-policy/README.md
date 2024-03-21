# Azure Policy

This module is used to create Azure Policy constraints and mutations.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.71.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.71.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/data-sources/resource_group.html) | data |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/data-sources/kubernetes_cluster) | data |
| [azurerm_policy_definition.azure_remove_node_spot_taints](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.k8s_block_node_port](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.k8s_secrets_store_csi_unique_volume](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.flux_require_service_account](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.k8s_pod_priority_class](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.k8s_require_ingress_class](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.flux_disable_cross_namespace_source](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.azure_identity_format](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.mutations](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_set_definition.xks](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/azurerm_policy_set_definition) | resource |
| [azurerm_resource_policy_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.71.0/docs/resources/azurerm_resource_policy_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | The name for the Azure Kubernetes Service (AKS) cluster | `string` | n/a | yes |
| <a name="input_aks_name_suffix"></a> [aks\_name\_suffix](#input\_aks\_name\_suffix) | The suffix for the Azure Kubernetes Service (AKS) cluster | `number` | n/a | yes |
| <a name="input_azure_policy_enabled"></a> [azure\_policy\_enabled](#input\_azure\_policy\_enabled) | Should Azure Policy be enabled | `bool` | `false` | no |
| <a name="input_azure_policy_config"></a> [azure\_policy\_config](#input\_azure\_policy\_config) | Configuration for Aure Policy | <pre>object({<br>  exclude_namespaces  = list(string)<br>  mutations           = list(object({<br>    name              = string<br>    display_name      = string<br>    template          = string<br>  }))<br>})<br></pre>| `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_tenant_namespaces"></a> [tenant\_namespaces](#input\_tenant\_namespaces) | List of tenant namespaces for Flux | `list(string)` | n/a | yes |

## Outputs

No outputs.