## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.107.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_group.aks_managed_identity](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azuread_group.cluster_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azuread_group.cluster_view](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azuread_group.edit](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azuread_group.view](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environemnt | `string` | n/a | yes |
| <a name="input_group_name_prefix"></a> [group\_name\_prefix](#input\_group\_name\_prefix) | Prefix for Azure AD groups | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The Kubernetes namespaces to create Azure AD groups for | <pre>list(<br/>    object({<br/>      name = string<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aad_groups"></a> [aad\_groups](#output\_aad\_groups) | Azure AD groups |
