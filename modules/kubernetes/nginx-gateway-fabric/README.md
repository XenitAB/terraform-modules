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
| [git_repository_file.ingress_nginx](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [kubernetes_namespace.nginx_gateway](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_gateway_config"></a> [gateway\_config](#input\_gateway\_config) | Gateway Fabric configuration | <pre>object({<br/>    logging_level     = optional(string, "info")<br/>    replica_count     = optional(number, 2)<br/>    telemetry_enabled = optional(bool, true)<br/>    telemetry_config = optional(object({<br/>      endpoint    = optional(string, "")<br/>      interval    = optional(string, "")<br/>      batch_size  = optional(number, 0)<br/>      batch_count = optional(number, 0)<br/>    }), {})<br/>  })</pre> | n/a | yes |
| <a name="input_nginx_config"></a> [nginx\_config](#input\_nginx\_config) | Global nginx configuration that will be applied to GatewayClass. | <pre>object({<br/>    allow_snippet_annotations = optional(bool, false)<br/>    http_snippet              = optional(string, "")<br/>    extra_config              = optional(map(string), {})<br/>    extra_headers             = optional(map(string), {})<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
