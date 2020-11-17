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
| dns\_provider | DNS provider to use. | `string` | n/a | yes |
| sources | k8s resource types to observe | `list(string)` | <pre>[<br>  "ingress"<br>]</pre> | no |

## Outputs

No output.

