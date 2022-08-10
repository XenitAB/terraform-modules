# Promtail

Adds [Promtail](https://github.com/grafana/helm-charts/tree/main/charts/promtail) to a Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.6 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.5.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.promtail](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_config"></a> [aws\_config](#input\_aws\_config) | AWS specific configuration | <pre>object({<br>    role_arn = string<br>  })</pre> | <pre>{<br>  "role_arn": ""<br>}</pre> | no |
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br>    azure_key_vault_name = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>      tenant_id   = string<br>    })<br>  })</pre> | <pre>{<br>  "azure_key_vault_name": "",<br>  "identity": {<br>    "client_id": "",<br>    "resource_id": "",<br>    "tenant_id": ""<br>  }<br>}</pre> | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Name of cloud provider | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the K8S cluster | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment in which the promtail instance is deployed | `string` | n/a | yes |
| <a name="input_excluded_namespaces"></a> [excluded\_namespaces](#input\_excluded\_namespaces) | Namespaces to not ship logs from | `list(string)` | `[]` | no |
| <a name="input_loki_address"></a> [loki\_address](#input\_loki\_address) | The address of the Loki instance to send logs to | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The tenant id | `string` | n/a | yes |

## Outputs

No outputs.
