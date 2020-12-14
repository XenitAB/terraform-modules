## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| aws | 3.20.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.20.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dns\_zone | The DNS Zone that will be used by the EKS cluster | `string` | n/a | yes |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| name | Common name for the environment | `string` | n/a | yes |
| vpc\_config | The configuration for the VPC | <pre>object({<br>    vpc_cidr_block    = string<br>    public_cidr_block = string<br>  })</pre> | n/a | yes |

## Outputs

No output.

