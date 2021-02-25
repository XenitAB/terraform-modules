## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| aws | 3.29.1 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.29.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dns\_zone | The DNS Zone that will be used by the EKS cluster | `string` | n/a | yes |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| name | Common name for the environment | `string` | n/a | yes |
| vpc\_config | The configuration for the VPC | <pre>object({<br>    cidr_block = string<br>    public_subnet = object({<br>      cidr_block = string<br>      tags       = map(string)<br>    })<br>  })</pre> | n/a | yes |

## Outputs

No output.

