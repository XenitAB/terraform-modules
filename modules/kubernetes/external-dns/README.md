# External DNS (external-dns)

This module is used to add [`external-dns`](https://github.com/kubernetes-sigs/external-dns) to Kubernetes clusters.

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
| aws\_config | AWS specific configuration | <pre>object({<br>    role_arn = string,<br>    region   = string<br>  })</pre> | <pre>{<br>  "region": "",<br>  "role_arn": ""<br>}</pre> | no |
| azure\_config | AWS specific configuration | <pre>object({<br>    subscription_id = string,<br>    tenant_id       = string,<br>    resource_group  = string,<br>    client_id       = string,<br>    resource_id     = string<br>  })</pre> | <pre>{<br>  "client_id": "",<br>  "resource_group": "",<br>  "resource_id": "",<br>  "subscription_id": "",<br>  "tenant_id": ""<br>}</pre> | no |
| dns\_provider | DNS provider to use. | `string` | n/a | yes |
| sources | k8s resource types to observe | `list(string)` | <pre>[<br>  "ingress",<br>  "service"<br>]</pre> | no |
| txt\_owner\_id | The txt-owner-id for external-dns | `string` | n/a | yes |

## Outputs

No output.
