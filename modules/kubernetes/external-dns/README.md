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
| azure\_client\_id | n/a | `string` | `""` | no |
| azure\_resource\_group | n/a | `string` | `""` | no |
| azure\_subscription\_id | n/a | `string` | `""` | no |
| azure\_tenant\_id | n/a | `string` | `""` | no |
| dns\_provider | DNS provider to use. | `string` | n/a | yes |
| sources | k8s resource types to observe | `list(string)` | <pre>[<br>  "ingress"<br>]</pre> | no |

## Outputs

No output.

