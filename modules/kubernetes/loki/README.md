# Grafana Loki

This module is used to add [`loki`](https://github.com/grafana/loki) to Kubernetes clusters (tested with AKS).

## Details

This module will also add `minio` (S3 Gateway to Azure Storage Account), `fluent-bit` and `grafana`.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| azurerm | 2.48.0 |
| helm | 2.0.2 |
| kubernetes | 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 2.48.0 |
| helm | 2.0.2 |
| kubernetes | 2.0.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environment (short name) to use for the deploy | `string` | n/a | yes |
| kubernetes\_namespace\_name | The Kubernetes namespace name | `string` | `"loki"` | no |
| location\_short | The Azure region short name. | `string` | n/a | yes |
| loki\_helm\_chart\_name | The helm chart name for loki | `string` | `"loki-stack"` | no |
| loki\_helm\_release\_name | The helm release name for loki | `string` | `"loki"` | no |
| loki\_helm\_repository | The helm repository for loki | `string` | `"https://grafana.github.io/loki/charts"` | no |
| minio\_helm\_chart\_name | The helm chart name for minio | `string` | `"minio"` | no |
| minio\_helm\_release\_name | The helm release name for minio | `string` | `"loki-minio"` | no |
| minio\_helm\_repository | The helm repository for minio | `string` | `"https://helm.min.io/"` | no |
| name | The name to use for the deploy | `string` | n/a | yes |
| resource\_group\_name | The resource group name | `string` | `""` | no |
| storage\_account\_configuration | The storage account configuration | <pre>object({<br>    account_tier             = string<br>    account_replication_type = string<br>    account_kind             = string<br>  })</pre> | <pre>{<br>  "account_kind": "StorageV2",<br>  "account_replication_type": "GRS",<br>  "account_tier": "Standard"<br>}</pre> | no |
| storage\_account\_name | The storage account name | `string` | `""` | no |
| storage\_container\_name | The storage container name | `string` | `"loki"` | no |

## Outputs

No output.

