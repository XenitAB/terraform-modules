## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.48.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.48.0 |
| <a name="provider_aws.eks_admin"></a> [aws.eks\_admin](#provider\_aws.eks\_admin) | 3.48.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.core_dns](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/iam_openid_connect_provider) | resource |
| [null_resource.update_eks_cni](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_subnet.cluster](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/subnet) | data source |
| [aws_subnet.node](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/subnet) | data source |
| [tls_certificate.thumbprint](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#input\_aws\_kms\_key\_arn) | eks secrets customer master key | `string` | n/a | yes |
| <a name="input_cluster_role_arn"></a> [cluster\_role\_arn](#input\_cluster\_role\_arn) | IAM role to attach to EKS cluster | `string` | n/a | yes |
| <a name="input_eks_config"></a> [eks\_config](#input\_eks\_config) | The EKS Config | <pre>object({<br>    kubernetes_version = string<br>    cidr_block         = string<br>    node_groups = list(object({<br>      name            = string<br>      release_version = string<br>      min_size        = number<br>      max_size        = number<br>      instance_types  = list(string)<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_eks_name_suffix"></a> [eks\_name\_suffix](#input\_eks\_name\_suffix) | The suffix for the eks clusters | `number` | `1` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Common name for the environment | `string` | n/a | yes |
| <a name="input_node_group_role_arn"></a> [node\_group\_role\_arn](#input\_node\_group\_role\_arn) | IAM role to attach to EKS node groups | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Kube config for the created EKS cluster |
