## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| aws | 3.34.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.34.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_availability_zones](https://registry.terraform.io/providers/hashicorp/aws/3.34.0/docs/data-sources/availability_zones) |
| [aws_eip](https://registry.terraform.io/providers/hashicorp/aws/3.34.0/docs/resources/eip) |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/3.34.0/docs/resources/internet_gateway) |
| [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/3.34.0/docs/resources/nat_gateway) |
| [aws_route](https://registry.terraform.io/providers/hashicorp/aws/3.34.0/docs/resources/route) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/3.34.0/docs/resources/route53_zone) |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/3.34.0/docs/resources/route_table) |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/3.34.0/docs/resources/route_table_association) |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/3.34.0/docs/resources/subnet) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/3.34.0/docs/resources/vpc) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dns\_zone | The DNS Zone that will be used by the EKS cluster | `string` | n/a | yes |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| name | Common name for the environment | `string` | n/a | yes |
| vpc\_config | The configuration for the VPC | <pre>object({<br>    cidr_block = string<br>    public_subnet = object({<br>      cidr_block = string<br>      tags       = map(string)<br>    })<br>  })</pre> | n/a | yes |

## Outputs

No output.
