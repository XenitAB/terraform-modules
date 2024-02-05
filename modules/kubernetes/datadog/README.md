# Datadog

Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.
This module is built to only gather application data.
API vs APP key.
API is used to send metrics to datadog from the agents.
APP key is used to be able to manage configuration inside datadog like alarms.
https://docs.datadoghq.com/account_management/api-app-keys/

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
| [git_repository_file.aws_config](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.azure_config](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.datadog](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.datadog_operator](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apm_ignore_resources"></a> [apm\_ignore\_resources](#input\_apm\_ignore\_resources) | The resources that shall be excluded from APM | `list(string)` | n/a | yes |
| <a name="input_aws_config"></a> [aws\_config](#input\_aws\_config) | AWS specific configuration | <pre>object({<br>    role_arn = string<br>  })</pre> | <pre>{<br>  "role_arn": ""<br>}</pre> | no |
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br>    azure_key_vault_name = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>      tenant_id   = string<br>    })<br>  })</pre> | <pre>{<br>  "azure_key_vault_name": "",<br>  "identity": {<br>    "client_id": "",<br>    "resource_id": "",<br>    "tenant_id": ""<br>  }<br>}</pre> | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Name of cloud provider | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_datadog_site"></a> [datadog\_site](#input\_datadog\_site) | Site to connect Datadog agent | `string` | `"datadoghq.eu"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Cluster environment | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Cluster location | `string` | n/a | yes |
| <a name="input_namespace_include"></a> [namespace\_include](#input\_namespace\_include) | The namespace that should be checked by Datadog, example: kube\_namespace:NAMESPACE kube\_namespace:NAMESPACE2 | `list(string)` | n/a | yes |

## Outputs

No outputs.
