# Controle plan logs

This module is used to run a small [vector](https://vector.dev/) deployment inside the cluster.
It listens to a message queue, parses the output and pushes it to stdout.

vector.toml includes the config how to connect to it's different endpoints.
Vector supports unit testing, and to verfiy it's config you can run `vector test vector.toml`.

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
| [git_repository_file.vector](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.vector_extras](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br>    azure_key_vault_name = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>      tenant_id   = string<br>    })<br>    eventhub_hostname = string<br>    eventhub_name     = string<br>  })</pre> | <pre>{<br>  "azure_key_vault_name": "",<br>  "eventhub_hostname": "",<br>  "eventhub_name": "",<br>  "identity": {<br>    "client_id": "",<br>    "resource_id": "",<br>    "tenant_id": ""<br>  }<br>}</pre> | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |

## Outputs

No outputs.
