# Gateway API

This module is used to add [`gateway-api`](https://github.com/kubernetes-sigs/gateway-api) CRDs from the experimental channel to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_gateway_api_config"></a> [gateway\_api\_config](#input\_gateway\_api\_config) | The Gateway API configuration | <pre>object({<br/>    api_version       = optional(string, "v1.2.0")<br/>    api_channel       = optional(string, "standard")<br/>    gateway_name      = optional(string, "")<br/>    gateway_namespace = optional(string, "")<br/>  })</pre> | `{}` | no |

## Outputs

No outputs.
