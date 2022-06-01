# IRSA

Creates IAM roles configured to work with EKS IRSA.
Configures the important trust polcies to allow Kubernetes Service Accounts
to assume the specific role.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.permissions](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.permissions](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Name of Kubernetes Namespace to trust | `string` | n/a | yes |
| <a name="input_kubernetes_service_account"></a> [kubernetes\_service\_account](#input\_kubernetes\_service\_account) | Name of Kubernetes Service Account to trust | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of created IAM role and policy | `string` | n/a | yes |
| <a name="input_oidc_providers"></a> [oidc\_providers](#input\_oidc\_providers) | OIDC provider configuration | <pre>list(object({<br>    url = string<br>    arn = string<br>  }))</pre> | n/a | yes |
| <a name="input_policy_json"></a> [policy\_json](#input\_policy\_json) | Permissions to apply to the created role | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the created role |
