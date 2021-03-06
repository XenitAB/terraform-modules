## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| aws | 3.31.0 |
| tls | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.31.0 |
| tls | 3.1.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_availability_zones](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/data-sources/availability_zones) |
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/data-sources/caller_identity) |
| [aws_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/resources/eks_cluster) |
| [aws_eks_cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/data-sources/eks_cluster_auth) |
| [aws_eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/resources/eks_node_group) |
| [aws_iam_openid_connect_provider](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/resources/iam_openid_connect_provider) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/resources/iam_role_policy_attachment) |
| [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/data-sources/nat_gateway) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/data-sources/region) |
| [aws_route](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/resources/route) |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/resources/route_table) |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/resources/route_table_association) |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/resources/subnet) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/3.31.0/docs/data-sources/vpc) |
| [tls_certificate](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/data-sources/certificate) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| core\_name | The core name for the environment | `string` | n/a | yes |
| eks\_config | The EKS Config | <pre>object({<br>    kubernetes_version = string<br>    cidr_block         = string<br>    node_groups = list(object({<br>      name            = string<br>      release_version = string<br>      min_size        = number<br>      max_size        = number<br>      disk_size       = number<br>      instance_types  = list(string)<br>    }))<br>  })</pre> | n/a | yes |
| eks\_name\_suffix | The suffix for the eks clusters | `number` | `1` | no |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| name | Common name for the environment | `string` | n/a | yes |
| velero\_config | Velero configuration | <pre>object({<br>    s3_bucket_arn = string<br>    s3_bucket_id  = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cert\_manager\_config | Configuration for Cert Manager |
| external\_dns\_config | Configuration for External DNS |
| external\_secrets\_config | Configuration for External DNS |
| kube\_config | Kube config for the created EKS cluster |
| velero\_config | Configuration for Velero |
