## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| aws | 3.29.1 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.29.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| name | Common name for the environment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| velero\_config | ARN of velero s3 backup bucket |

