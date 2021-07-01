## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.48.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.48.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/iam_openid_connect_provider) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/region) | data source |
| [aws_subnet.cluster](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/subnet) | data source |
| [tls_certificate.thumbprint](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_core_name"></a> [core\_name](#input\_core\_name) | The core name for the environment | `string` | n/a | yes |
| <a name="input_eks_config"></a> [eks\_config](#input\_eks\_config) | The EKS Config | <pre>object({<br>    kubernetes_version = string<br>    cidr_block         = string<br>    node_groups = list(object({<br>      name            = string<br>      release_version = string<br>      min_size        = number<br>      max_size        = number<br>      instance_types  = list(string)<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_eks_name_suffix"></a> [eks\_name\_suffix](#input\_eks\_name\_suffix) | The suffix for the eks clusters | `number` | `1` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Common name for the environment | `string` | n/a | yes |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Velero configuration | <pre>object({<br>    s3_bucket_arn = string<br>    s3_bucket_id  = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_config"></a> [cert\_manager\_config](#output\_cert\_manager\_config) | Configuration for Cert Manager |
| <a name="output_external_dns_config"></a> [external\_dns\_config](#output\_external\_dns\_config) | Configuration for External DNS |
| <a name="output_external_secrets_config"></a> [external\_secrets\_config](#output\_external\_secrets\_config) | Configuration for External DNS |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Kube config for the created EKS cluster |
| <a name="output_velero_config"></a> [velero\_config](#output\_velero\_config) | Configuration for Velero |
