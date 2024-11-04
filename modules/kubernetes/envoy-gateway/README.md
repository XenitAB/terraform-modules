# Nginx Gateway Fabric

This module is used to add [`nginx-gateway-fabric`](https://docs.nginx.com/nginx-gateway-fabric/) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.envoy_gateway](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [kubernetes_namespace.envoy_gateway](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_envoy_gateway_config"></a> [envoy\_gateway\_config](#input\_envoy\_gateway\_config) | Configuration for the username and password | <pre>object({<br/>    logging_level             = optional(string, "info")<br/>    pod_labels                = optional(string, "")<br/>    replicas_count            = optional(number, 2)<br/>    resources_memory_limit    = optional(string, "")<br/>    resources_cpu_requests    = optional(string, "")<br/>    resources_memory_requests = optional(string, "")<br/>    service_annotations       = optional(string, "")<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
