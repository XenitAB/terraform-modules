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
| create\_self\_signed\_cert | If true helm will generate a self signed cert | `bool` | `false` | no |
| namespaces | Namespaces to apply mutating hooks to | `list(string)` | n/a | yes |

## Outputs

No output.

