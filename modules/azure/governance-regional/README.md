# Governance (Regional)

This module is used for governance on a regional level and not using any specific resource groups. Replaces the old `governance` together with `governance-global`.

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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_names"></a> [names](#module\_names) | ../names | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_application_password.delegate_kv_aad](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application_password) | resource |
| [azuread_application_password.sub_reader_sp](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application_password) | resource |
| [azurerm_key_vault.delegate_kv](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.ap_kvreader_sp](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.ap_owner_spn](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.ap_rg_aad_group](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.ap_rg_sp](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.ap_sub_aad_group_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.ap_sub_aad_group_owner](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.aad_sp](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.delegate_kv_aad](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.sub_reader_sp](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_secret) | resource |
| [azurerm_management_lock.rg](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/management_lock) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aad_sp](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rg_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rg_owner](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rg_reader](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azuread_service_principal.owner_spn](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/service_principal) | data source |
| [azurecaf_name.azurerm_key_vault_delegate_kv](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurecaf_name.azurerm_resource_group_rg](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/data-sources/name) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_sp_passwords"></a> [aad\_sp\_passwords](#input\_aad\_sp\_passwords) | Application password per resource group. | `map(string)` | n/a | yes |
| <a name="input_azuread_apps"></a> [azuread\_apps](#input\_azuread\_apps) | Azure AD applications from global | <pre>object({<br/>    delegate_kv = map(object({<br/>      display_name                = string<br/>      application_object_id       = string<br/>      client_id                   = string<br/>      service_principal_object_id = string<br/>    }))<br/>    rg_contributor = map(object({<br/>      display_name                = string<br/>      application_object_id       = string<br/>      client_id                   = string<br/>      service_principal_object_id = string<br/>    }))<br/>    sub_reader = object({<br/>      display_name                = string<br/>      application_object_id       = string<br/>      client_id                   = string<br/>      service_principal_object_id = string<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_azuread_groups"></a> [azuread\_groups](#input\_azuread\_groups) | Azure AD groups from global | <pre>object({<br/>    rg_owner = map(object({<br/>      id = string<br/>    }))<br/>    rg_contributor = map(object({<br/>      id = string<br/>    }))<br/>    rg_reader = map(object({<br/>      id = string<br/>    }))<br/>    sub_owner = object({<br/>      id = string<br/>    })<br/>    sub_contributor = object({<br/>      id = string<br/>    })<br/>    sub_reader = object({<br/>      id = string<br/>    })<br/>    service_endpoint_join = object({<br/>      id = string<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_core_name"></a> [core\_name](#input\_core\_name) | The commonName for the core infrastructure | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location for the subscription | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The location shortname for the subscription | `string` | n/a | yes |
| <a name="input_owner_service_principal_name"></a> [owner\_service\_principal\_name](#input\_owner\_service\_principal\_name) | The name of the service principal that will be used to run terraform and is owner of the subsciptions | `string` | n/a | yes |
| <a name="input_resource_group_configs"></a> [resource\_group\_configs](#input\_resource\_group\_configs) | Resource group configuration | <pre>list(<br/>    object({<br/>      common_name                        = string<br/>      delegate_aks                       = bool # Delegate aks permissions<br/>      delegate_key_vault                 = bool # Delegate KeyVault creation<br/>      delegate_service_endpoint          = bool # Delegate Service Endpoint permissions<br/>      delegate_service_principal         = bool # Delegate Service Principal<br/>      lock_resource_group                = bool # Adds management_lock (CanNotDelete) to the resource group<br/>      disable_unique_suffix              = bool # Disable unique_suffix on resource names<br/>      key_vault_purge_protection_enabled = optional(bool, false)<br/>      tags                               = map(string)<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_resource_name_overrides"></a> [resource\_name\_overrides](#input\_resource\_name\_overrides) | A way to override the resource names | `any` | `null` | no |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | Output each keyvault name |
