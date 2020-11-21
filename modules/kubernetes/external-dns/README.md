# External DNS (external-dns)

This module is used to add [`external-dns`](https://github.com/kubernetes-sigs/external-dns) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| helm | 1.3.2 |

## Providers

| Name | Version |
|------|---------|
| helm | 1.3.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_client\_id | Client ID for MSI authentication | `string` | `""` | no |
| azure\_resource\_group | Azure resource group for DNS zone | `string` | `""` | no |
| azure\_resource\_id | Principal ID fo MSI authentication | `string` | `""` | no |
| azure\_subscription\_id | Azure subscription ID for DNS zone | `string` | `""` | no |
| azure\_tenant\_id | Azure tenant ID for DNS zone | `string` | `""` | no |
| dns\_provider | DNS provider to use. | `string` | n/a | yes |
| sources | k8s resource types to observe | `list(string)` | <pre>[<br>  "ingress"<br>]</pre> | no |

## Outputs

No output.

