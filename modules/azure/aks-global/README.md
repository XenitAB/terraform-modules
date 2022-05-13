# Azure Kubernetes Service - Global

This module is used to create resources that are used by AKS clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.19.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.19.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_group.aks_managed_identity](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group) | resource |
| [azuread_group.cluster_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group) | resource |
| [azuread_group.cluster_view](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group) | resource |
| [azuread_group.edit](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group) | resource |
| [azuread_group.view](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/group) | resource |
| [azurerm_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/dns_zone) | resource |
| [azurerm_role_assignment.external_dns_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_dns_msi](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_dns_rg_read](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.external_dns](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_group_name_prefix"></a> [aks\_group\_name\_prefix](#input\_aks\_group\_name\_prefix) | Prefix for AKS Azure AD groups | `string` | `"aks"` | no |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | List of DNS Zone to create | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the deploy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes | <pre>list(<br>    object({<br>      name                    = string<br>      delegate_resource_group = bool<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aad_groups"></a> [aad\_groups](#output\_aad\_groups) | Azure AD groups |
| <a name="output_aks_managed_identity_group_id"></a> [aks\_managed\_identity\_group\_id](#output\_aks\_managed\_identity\_group\_id) | The group id of aks managed identity |
| <a name="output_dns_zone"></a> [dns\_zone](#output\_dns\_zone) | DNS Zone to be used with external-dns |
| <a name="output_external_dns_identity"></a> [external\_dns\_identity](#output\_external\_dns\_identity) | MSI authentication identity for External DNS |
| <a name="output_namespaces"></a> [namespaces](#output\_namespaces) | Kubernetes namespaces |
