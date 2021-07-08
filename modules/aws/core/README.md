# Core

This module is used to configure a standard public/private VPC and accompanying Route53 zome.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.48.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.48.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.public](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/nat_gateway) | resource |
| [aws_route.peer](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/route) | resource |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/route) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/route) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/route53_zone) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/vpc) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/vpc_peering_connection) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | The DNS Zone host name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Common name for the deploy | `string` | n/a | yes |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | The configuration of the VPC | <pre>object({<br>    cidr_block = string<br>    public_subnets = list(object({<br>      cidr_block = string<br>      tags       = map(string)<br>    }))<br>    private_subnets = list(object({<br>      name_prefix             = string<br>      cidr_block              = string<br>      availability_zone_index = number<br>      public_routing_enabled  = bool<br>      tags                    = map(string)<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_vpc_peering_config"></a> [vpc\_peering\_config](#input\_vpc\_peering\_config) | VPC Peering configuration | <pre>object({<br>    peer_owner_id          = string<br>    peer_vpc_id            = string<br>    destination_cidr_block = string<br>  })</pre> | <pre>{<br>  "destination_cidr_block": "",<br>  "peer_owner_id": "",<br>  "peer_vpc_id": ""<br>}</pre> | no |
| <a name="input_vpc_peering_enabled"></a> [vpc\_peering\_enabled](#input\_vpc\_peering\_enabled) | If true vpc peering will be configured | `bool` | `true` | no |

## Outputs

No outputs.
