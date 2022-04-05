# Core

This module is used to configure an opinionated VPC for XKS.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_eip.public](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/eip) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/flow_log) | resource |
| [aws_iam_policy.flow_log](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.flow_log](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.permissions](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/nat_gateway) | resource |
| [aws_route.peering_accepter](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/route) | resource |
| [aws_route.peering_requester](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/route) | resource |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/route) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/route) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/route53_zone) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/vpc) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.peer](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.flow_log](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/data-sources/region) | data source |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/data-sources/vpc_peering_connection) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR block of the VPC. The prefix length of the CIDR block must be 18 or less | `string` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | The list of DNS Zone host names | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deployment | `string` | n/a | yes |
| <a name="input_flow_log_enabled"></a> [flow\_log\_enabled](#input\_flow\_log\_enabled) | Should flow logs be enabled | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Deployment name | `string` | n/a | yes |
| <a name="input_vpc_peering_config_accepter"></a> [vpc\_peering\_config\_accepter](#input\_vpc\_peering\_config\_accepter) | VPC Peering configuration accepter | <pre>list(object({<br>    name                   = string<br>    peer_owner_id          = string<br>    destination_cidr_block = string<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_peering_config_requester"></a> [vpc\_peering\_config\_requester](#input\_vpc\_peering\_config\_requester) | VPC Peering configuration requester | <pre>list(object({<br>    name                   = string<br>    peer_owner_id          = string<br>    peer_vpc_id            = string<br>    destination_cidr_block = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_zones"></a> [dns\_zones](#output\_dns\_zones) | n/a |
| <a name="output_private_subnets_ids"></a> [private\_subnets\_ids](#output\_private\_subnets\_ids) | The ids of the of private subnets created by this module |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The id of the VPC created by this module |
