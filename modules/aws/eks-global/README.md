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
| [aws_iam_policy.eks_admin](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_admin](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/iam_role) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/kms_key) | resource |
| [aws_kms_key.velero](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/kms_key) | resource |
| [aws_s3_bucket.velero](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/resources/s3_bucket) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.eks_admin_assume](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_admin_permission](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environemnt | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the deployment | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_kms_key_cmk"></a> [aws\_kms\_key\_cmk](#output\_aws\_kms\_key\_cmk) | eks secrets customer master key |
| <a name="output_cluster_role_arn"></a> [cluster\_role\_arn](#output\_cluster\_role\_arn) | EKS cluster IAM role |
| <a name="output_eks_admin_role_arn"></a> [eks\_admin\_role\_arn](#output\_eks\_admin\_role\_arn) | ARN for IAM role that should be used to create an EKS cluster |
| <a name="output_node_group_role_arn"></a> [node\_group\_role\_arn](#output\_node\_group\_role\_arn) | EKS node grouop IAM role |
| <a name="output_velero_config"></a> [velero\_config](#output\_velero\_config) | ARN of velero s3 backup bucket |
