# External Secrets

Adds [`external-secrets`](https://github.com/external-secrets/kubernetes-external-secrets) to a Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| helm | 2.0.3 |
| kubernetes | 2.0.3 |

## Providers

| Name | Version |
|------|---------|
| helm | 2.0.3 |
| kubernetes | 2.0.3 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/2.0.3/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.3/docs/resources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_config | AWS specific configuration | <pre>object({<br>    role_arn = string,<br>    region   = string<br>  })</pre> | <pre>{<br>  "region": "",<br>  "role_arn": ""<br>}</pre> | no |

## Outputs

No output.
