## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_group.aks_managed_identity](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.cluster_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.cluster_view](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.edit](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.view](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group_member.resource_group_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.resource_group_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.resource_group_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azuread_groups"></a> [azuread\_groups](#input\_azuread\_groups) | Azure AD groups from global | <pre>object({<br/>    rg_owner = map(object({<br/>      id = string<br/>    }))<br/>    rg_contributor = map(object({<br/>      id = string<br/>    }))<br/>    rg_reader = map(object({<br/>      id = string<br/>    }))<br/>    sub_owner = object({<br/>      id = string<br/>    })<br/>    sub_contributor = object({<br/>      id = string<br/>    })<br/>    sub_reader = object({<br/>      id = string<br/>    })<br/>    service_endpoint_join = object({<br/>      id = string<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environemnt | `string` | n/a | yes |
| <a name="input_group_name_prefix"></a> [group\_name\_prefix](#input\_group\_name\_prefix) | Prefix for Azure AD groups | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The Kubernetes namespaces to create Azure AD groups for | <pre>list(<br/>    object({<br/>      name = string<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |

## Outputs

No outputs.
