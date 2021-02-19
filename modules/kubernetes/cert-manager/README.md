# Certificate manager (cert-manager)

This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| helm | 2.0.2 |
| kubernetes | 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| helm | 2.0.2 |
| kubernetes | 2.0.2 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/2.0.2/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.2/docs/resources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acme\_server | ACME server to add to the created ClusterIssuer | `string` | `"https://acme-v02.api.letsencrypt.org/directory"` | no |
| aws\_config | AWS specific configuration | <pre>object({<br>    region         = string,<br>    hosted_zone_id = string,<br>    role_arn       = string,<br>  })</pre> | <pre>{<br>  "hosted_zone_id": "",<br>  "region": "",<br>  "role_arn": ""<br>}</pre> | no |
| azure\_config | Azure specific configuration | <pre>object({<br>    subscription_id     = string,<br>    hosted_zone_name    = string,<br>    resource_group_name = string,<br>    client_id           = string,<br>    resource_id         = string,<br>  })</pre> | <pre>{<br>  "client_id": "",<br>  "hosted_zone_name": "",<br>  "resource_group_name": "",<br>  "resource_id": "",<br>  "subscription_id": ""<br>}</pre> | no |
| cloud\_provider | Cloud provider to use. | `string` | n/a | yes |
| notification\_email | Email address to send certificate expiration notifications | `string` | n/a | yes |

## Outputs

No output.
