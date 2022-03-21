## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.63.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.19.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.63.0 |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.19.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.eks1](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.eks2](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.eks_admin](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_admin](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/iam_role) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/kms_key) | resource |
| [aws_kms_key.velero](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/kms_key) | resource |
| [aws_s3_bucket.velero](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.velero](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/s3_bucket_public_access_block) | resource |
| [azuread_group.cluster_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group) | resource |
| [azuread_group.cluster_view](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group) | resource |
| [azuread_group.edit](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group) | resource |
| [azuread_group.view](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group) | resource |
| [azuread_group_member.resource_group_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group_member) | resource |
| [azuread_group_member.resource_group_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group_member) | resource |
| [azuread_group_member.resource_group_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group_member) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.eks_admin_assume](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_admin_permission](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/data-sources/region) | data source |
| [azuread_group.resource_group_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/data-sources/group) | data source |
| [azuread_group.resource_group_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/data-sources/group) | data source |
| [azuread_group.resource_group_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | Prefix for Azure AD Groups | `string` | `"az"` | no |
| <a name="input_eks_cloudwatch_retention_period"></a> [eks\_cloudwatch\_retention\_period](#input\_eks\_cloudwatch\_retention\_period) | eks cloudwatch retention period | `number` | `30` | no |
| <a name="input_eks_group_name_prefix"></a> [eks\_group\_name\_prefix](#input\_eks\_group\_name\_prefix) | Prefix for EKS Azure AD groups | `string` | `"eks"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environemnt | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the deployment | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix to add to unique names such as S3 buckets and IAM roles | `string` | `"xks"` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes | <pre>list(<br>    object({<br>      name                    = string<br>      delegate_resource_group = bool<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aad_groups"></a> [aad\_groups](#output\_aad\_groups) | Azure AD groups |
| <a name="output_cluster_role_arn"></a> [cluster\_role\_arn](#output\_cluster\_role\_arn) | EKS cluster IAM role |
| <a name="output_eks_admin_role_arn"></a> [eks\_admin\_role\_arn](#output\_eks\_admin\_role\_arn) | ARN for IAM role that should be used to create an EKS cluster |
| <a name="output_eks_encryption_key_arn"></a> [eks\_encryption\_key\_arn](#output\_eks\_encryption\_key\_arn) | KMS key to be used for EKS secret encryption |
| <a name="output_node_group_role_arn"></a> [node\_group\_role\_arn](#output\_node\_group\_role\_arn) | EKS node grouop IAM role |
| <a name="output_velero_config"></a> [velero\_config](#output\_velero\_config) | ARN of velero s3 backup bucket |
