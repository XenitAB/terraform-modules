# Envoy Gateway

This module is used to add [`envoy-gateway`](https://gateway.envoyproxy.io/docs/) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.19.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.19.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_policy_definition.envoy_gateway_require_tls](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_set_definition.xks](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/policy_set_definition) | resource |
| [git_repository_file.envoy_gateway](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_envoy_gateway_config"></a> [envoy\_gateway\_config](#input\_envoy\_gateway\_config) | Configuration for the username and password | <pre>object({<br/>    logging_level             = optional(string, "info")<br/>    replicas_count            = optional(number, 2)<br/>    resources_memory_limit    = optional(string, "")<br/>    resources_cpu_requests    = optional(string, "")<br/>    resources_memory_requests = optional(string, "")<br/>  })</pre> | `{}` | no |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |
| <a name="input_tenant_namespaces"></a> [tenant\_namespaces](#input\_tenant\_namespaces) | List of tenant namespaces | `list(string)` | `[]` | no |

## Outputs

No outputs.
