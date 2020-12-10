# Certificate manager (cert-manager)

This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.

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
| acme\_server | ACME server to add to the created ClusterIssuer | `string` | `"https://acme-v02.api.letsencrypt.org/directory"` | no |
| input\_depends\_on | Input dependency for module | `any` | `{}` | no |
| notification\_email | Email address to send certificate expiration notifications | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| output\_depends\_on | Output dependency for module |

