## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.eks_admin](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_admin](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_admin](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.velero](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/resources/kms_key) | resource |
| [aws_s3_bucket.velero](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/resources/s3_bucket) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.eks_admin_assume](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_admin_permission](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Common name for the environment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_velero_config"></a> [velero\_config](#output\_velero\_config) | ARN of velero s3 backup bucket |
