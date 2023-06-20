# Node TTL

This module is used to add [`node-ttl`](https://github.com/XenitAB/node-ttl) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.2/docs/resources/repository_file) | resource |
| [git_repository_file.node_ttl](https://registry.terraform.io/providers/xenitab/git/0.0.2/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_status_config_map_namespace"></a> [status\_config\_map\_namespace](#input\_status\_config\_map\_namespace) | Namespace where Cluster Autoscaler status ConfigMap is created | `string` | n/a | yes |

## Outputs

No outputs.
