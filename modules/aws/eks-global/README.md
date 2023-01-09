## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.31.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.28.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azad_kube_proxy"></a> [azad\_kube\_proxy](#module\_azad\_kube\_proxy) | ../../azure-ad/azad-kube-proxy | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.eks1](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.eks2](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.eks_admin](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_admin](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/iam_role) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/kms_key) | resource |
| [aws_kms_key.velero](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/kms_key) | resource |
| [aws_s3_bucket.velero](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.velero](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_public_access_block.velero](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.velero](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.velero](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.eks_admin_assume](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_admin_permission](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/4.31.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azad_kube_proxy_config"></a> [azad\_kube\_proxy\_config](#input\_azad\_kube\_proxy\_config) | Azure AD Kubernetes Proxy configuration | <pre>object({<br>    cluster_name_prefix = string<br>    proxy_url_override  = string<br>  })</pre> | <pre>{<br>  "cluster_name_prefix": "eks",<br>  "proxy_url_override": ""<br>}</pre> | no |
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | List of DNS Zone to create | `list(string)` | n/a | yes |
| <a name="input_eks_admin_assume_principal_ids"></a> [eks\_admin\_assume\_principal\_ids](#input\_eks\_admin\_assume\_principal\_ids) | ThePrincipal IDs that are allowed to assume EKS Admin role | `list(string)` | n/a | yes |
| <a name="input_eks_cloudwatch_retention_period"></a> [eks\_cloudwatch\_retention\_period](#input\_eks\_cloudwatch\_retention\_period) | eks cloudwatch retention period | `number` | `30` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environemnt | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the deployment | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix to add to unique names such as S3 buckets and IAM roles | `string` | `"xks"` | no |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azad_kube_proxy"></a> [azad\_kube\_proxy](#output\_azad\_kube\_proxy) | The Azure AD Application config for azad-kube-proxy |
| <a name="output_cluster_role_arn"></a> [cluster\_role\_arn](#output\_cluster\_role\_arn) | EKS cluster IAM role |
| <a name="output_eks_admin_role_arn"></a> [eks\_admin\_role\_arn](#output\_eks\_admin\_role\_arn) | ARN for IAM role that should be used to create an EKS cluster |
| <a name="output_eks_encryption_key_arn"></a> [eks\_encryption\_key\_arn](#output\_eks\_encryption\_key\_arn) | KMS key to be used for EKS secret encryption |
| <a name="output_node_group_role_arn"></a> [node\_group\_role\_arn](#output\_node\_group\_role\_arn) | EKS node grouop IAM role |
| <a name="output_velero_config"></a> [velero\_config](#output\_velero\_config) | ARN of velero s3 backup bucket |
