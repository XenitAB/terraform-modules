# Grafana Loki

This module is used to add [`loki`](https://github.com/grafana/loki) to Kubernetes clusters (tested with AKS).

## Details

This module will also add `minio` (S3 Gateway to Azure Storage Account), `fluent-bit` and `grafana`.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.72.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.72.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.loki](https://registry.terraform.io/providers/hashicorp/azurerm/2.72.0/docs/resources/storage_account) | resource |
| [azurerm_storage_container.loki](https://registry.terraform.io/providers/hashicorp/azurerm/2.72.0/docs/resources/storage_container) | resource |
| [helm_release.loki_stack](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [helm_release.minio](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.72.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment (short name) to use for the deploy | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the deploy | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name | `string` | `""` | no |
| <a name="input_storage_account_configuration"></a> [storage\_account\_configuration](#input\_storage\_account\_configuration) | The storage account configuration | <pre>object({<br>    account_tier             = string<br>    account_replication_type = string<br>    account_kind             = string<br>  })</pre> | <pre>{<br>  "account_kind": "StorageV2",<br>  "account_replication_type": "GRS",<br>  "account_tier": "Standard"<br>}</pre> | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The storage account name | `string` | `""` | no |
| <a name="input_storage_container_name"></a> [storage\_container\_name](#input\_storage\_container\_name) | The storage container name | `string` | `"loki"` | no |

## Outputs

No outputs.
