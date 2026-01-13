# Envoy Gateway

This module is used to add [`envoy-gateway`](https://gateway.envoyproxy.io/docs/) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.19.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | >=0.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | >=0.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.envoy_gateway](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.envoy_gateway_require_tls_kyverno](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_envoy_gateway_config"></a> [envoy\_gateway\_config](#input\_envoy\_gateway\_config) | Configuration for the username and password | <pre>object({<br/>    logging_level             = optional(string, "info")<br/>    replicas_count            = optional(number, 2)<br/>    resources_memory_limit    = optional(string, "")<br/>    resources_cpu_requests    = optional(string, "")<br/>    resources_memory_requests = optional(string, "")<br/>  })</pre> | `{}` | no |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra configuration | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

No outputs.
