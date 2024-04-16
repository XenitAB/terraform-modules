# Velero

This module is used to add [`velero`](https://github.com/vmware-tanzu/velero) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
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
| [git_repository_file.velero](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.velero_extras](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br>    subscription_id           = string,<br>    resource_group            = string,<br>    client_id                 = string,<br>    resource_id               = string,<br>    storage_account_name      = string,<br>    storage_account_container = string<br>  })</pre> | <pre>{<br>  "client_id": "",<br>  "resource_group": "",<br>  "resource_id": "",<br>  "storage_account_container": "",<br>  "storage_account_name": "",<br>  "subscription_id": "",<br>  "tenant_id": ""<br>}</pre> | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |

## Outputs

No outputs.
