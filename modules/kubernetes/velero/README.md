# Velero

This module is used to add [`velero`](https://github.com/vmware-tanzu/velero) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| helm | 1.3.2 |
| kubernetes | 1.13.3 |

## Providers

| Name | Version |
|------|---------|
| helm | 1.3.2 |
| kubernetes | 1.13.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_client\_id | Client ID for MSI authentication | `string` | `""` | no |
| azure\_resource\_group | Azure resource group for DNS zone | `string` | `""` | no |
| azure\_resource\_id | Principal ID fo MSI authentication | `string` | `""` | no |
| azure\_storage\_account\_container | Azure storage account container name | `string` | `""` | no |
| azure\_storage\_account\_name | Azure storage account name | `string` | `""` | no |
| azure\_subscription\_id | Azure subscription ID for DNS zone | `string` | `""` | no |
| cloud\_provider | Cloud provider to use. | `string` | `"azure"` | no |

## Outputs

No output.

