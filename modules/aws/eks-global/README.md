## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| aws | 3.32.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.32.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/3.32.0/docs/data-sources/caller_identity) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/3.32.0/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/3.32.0/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/3.32.0/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/3.32.0/docs/resources/iam_role_policy_attachment) |
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/3.32.0/docs/resources/kms_key) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/3.32.0/docs/data-sources/region) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.32.0/docs/resources/s3_bucket) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| name | Common name for the environment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| velero\_config | ARN of velero s3 backup bucket |
