# Velero

This module is used to add [`velero`](https://github.com/vmware-tanzu/velero) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| helm | 2.0.3 |
| kubernetes | 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| helm | 2.0.3 |
| kubernetes | 2.0.2 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/2.0.3/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.2/docs/resources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_config | AWS specific configuration | <pre>object({<br>    role_arn     = string,<br>    region       = string,<br>    s3_bucket_id = string<br>  })</pre> | <pre>{<br>  "region": "",<br>  "role_arn": "",<br>  "s3_bucket_id": ""<br>}</pre> | no |
| azure\_config | AWS specific configuration | <pre>object({<br>    subscription_id           = string,<br>    resource_group            = string,<br>    client_id                 = string,<br>    resource_id               = string,<br>    storage_account_name      = string,<br>    storage_account_container = string<br>  })</pre> | <pre>{<br>  "client_id": "",<br>  "resource_group": "",<br>  "resource_id": "",<br>  "storage_account_container": "",<br>  "storage_account_name": "",<br>  "subscription_id": "",<br>  "tenant_id": ""<br>}</pre> | no |
| cloud\_provider | Cloud provider to use. | `string` | `"azure"` | no |

## Outputs

No output.
