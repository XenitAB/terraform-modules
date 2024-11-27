# Governance (Global)

This module is used for governance on a global level and not using any specific resource groups. Replaces the old `governance` together with `governance-regional`.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | 2.0.0-preview3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.7.0 |
| <a name="requirement_pal"></a> [pal](#requirement\_pal) | 0.2.5 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 2.0.0-preview3 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.7.0 |
| <a name="provider_pal"></a> [pal](#provider\_pal) | 0.2.5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_names"></a> [names](#module\_names) | ../names | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_application.aad_app](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application) | resource |
| [azuread_application.delegate_kv_aad](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application) | resource |
| [azuread_application.sub_reader_sp](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application) | resource |
| [azuread_application_password.aad_sp](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application_password) | resource |
| [azuread_application_password.owner_spn](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application_password) | resource |
| [azuread_group.acr_pull](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.acr_push](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.acr_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.rg_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.rg_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.rg_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.service_endpoint_join](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.sub_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.sub_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group.sub_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group) | resource |
| [azuread_group_member.acr_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.acr_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.acr_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.acr_reader_rg_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.acr_reader_rg_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.acr_reader_rg_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.acr_spn](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.service_endpoint_join_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.service_endpoint_join_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.service_endpoint_join_spn](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.sp_all_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.sub_all_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.sub_all_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.sub_all_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_service_principal.aad_sp](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/service_principal) | resource |
| [azuread_service_principal.delegate_kv_aad](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/service_principal) | resource |
| [azuread_service_principal.sub_reader_sp](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.sub_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sub_owner](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sub_reader](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sub_reader_sp](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [pal_management_partner.aad_sp](https://registry.terraform.io/providers/xenitab/pal/0.2.5/docs/resources/management_partner) | resource |
| [pal_management_partner.owner_spn](https://registry.terraform.io/providers/xenitab/pal/0.2.5/docs/resources/management_partner) | resource |
| [azuread_application.owner_spn](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/application) | data source |
| [azuread_group.all_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azuread_group.all_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azuread_group.all_reader](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azuread_service_principal.owner_spn](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/service_principal) | data source |
| [azuread_service_principal.sp_all_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/service_principal) | data source |
| [azurecaf_name.azuread_application_aad_app](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_application_delegate_kv_aad](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_application_sub_reader_sp](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_acr_pull](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_acr_push](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_acr_reader](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_all_contributor](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_all_owner](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_all_reader](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_rg_contributor](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_rg_owner](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_rg_reader](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_service_endpoint_join](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_sub_contributor](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_sub_owner](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azuread_group_sub_reader](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_group_name_prefix"></a> [aks\_group\_name\_prefix](#input\_aks\_group\_name\_prefix) | Prefix for AKS Azure AD groups | `string` | `"aks"` | no |
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | Prefix for Azure AD Groups | `string` | `"az"` | no |
| <a name="input_delegate_acr"></a> [delegate\_acr](#input\_delegate\_acr) | Should Azure Container Registry delegation be configured? | `bool` | `true` | no |
| <a name="input_delegate_sub_groups"></a> [delegate\_sub\_groups](#input\_delegate\_sub\_groups) | Should the subscription groups be delegated to global groups (example: az-sub-[subName]-all-owner) | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_owner_service_principal_name"></a> [owner\_service\_principal\_name](#input\_owner\_service\_principal\_name) | The name of the service principal that will be used to run terraform and is owner of the subsciptions | `string` | n/a | yes |
| <a name="input_partner_id"></a> [partner\_id](#input\_partner\_id) | Azure partner id to link service principal with | `string` | `""` | no |
| <a name="input_resource_group_configs"></a> [resource\_group\_configs](#input\_resource\_group\_configs) | Resource group configuration | <pre>list(<br/>    object({<br/>      common_name                = string<br/>      delegate_aks               = bool # Delegate aks permissions<br/>      delegate_key_vault         = bool # Delegate KeyVault creation<br/>      delegate_service_endpoint  = bool # Delegate Service Endpoint permissions<br/>      delegate_service_principal = bool # Delegate Service Principal<br/>      disable_unique_suffix      = bool # Disable unique_suffix on resource names<br/>      tags                       = map(string)<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_resource_name_overrides"></a> [resource\_name\_overrides](#input\_resource\_name\_overrides) | A way to override the resource names | `any` | `null` | no |
| <a name="input_service_principal_all_owner_name"></a> [service\_principal\_all\_owner\_name](#input\_service\_principal\_all\_owner\_name) | Name of the manually created SP-sub-all-owner | `string` | `null` | no |
| <a name="input_service_principal_name_prefix"></a> [service\_principal\_name\_prefix](#input\_service\_principal\_name\_prefix) | Prefix for service principals | `string` | `"sp"` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aad_sp_passwords"></a> [aad\_sp\_passwords](#output\_aad\_sp\_passwords) | Application password per resource group. |
| <a name="output_azuread_apps"></a> [azuread\_apps](#output\_azuread\_apps) | Output for Azure AD applications |
| <a name="output_azuread_groups"></a> [azuread\_groups](#output\_azuread\_groups) | Output for Azure AD Groups |
