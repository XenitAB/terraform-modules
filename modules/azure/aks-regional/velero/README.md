# Velero

Creates the resources needed by Velero.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.99.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [azurerm](#provider\_azurerm) | 3.99.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.99.0/docs/data-sources/resource_group) | data-source |
| [azurerm_storage_account.velero](https://registry.terraform.io/providers/hashicorp/azurerm/3.99.0/docs/resources/storage_account) | resource |
| [azurerm_storage_container.velero](https://registry.terraform.io/providers/hashicorp/azurerm/3.99.0/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.velero](https://registry.terraform.io/providers/hashicorp/azurerm/3.99.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_role_assignment.velero_msi](https://registry.terraform.io/providers/hashicorp/azurerm/3.99.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_storage_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/3.99.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.velero_rg_read](https://registry.terraform.io/providers/hashicorp/azurerm/3.99.0/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_managed_identity"></a> [aks\_managed\_identity](#input\_aks\_managed\_identity) | AKS Azure AD managed identity. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\environment) | The environment name to use for the deploy. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\location\_short) | The Azure region short name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the deploy. | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names. | `string` | n/a | yes |

## Outputs

No outputs.
