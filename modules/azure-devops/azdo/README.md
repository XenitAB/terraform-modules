## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.19.1 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | 0.2.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.19.1 |
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | 0.2.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application_password.this](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/resources/application_password) | resource |
| [azuredevops_serviceendpoint_azurerm.serviceendpoint](https://registry.terraform.io/providers/microsoft/azuredevops/0.2.1/docs/resources/serviceendpoint_azurerm) | resource |
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/data-sources/application) | data source |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/2.19.1/docs/data-sources/service_principal) | data source |
| [azuredevops_project.this](https://registry.terraform.io/providers/microsoft/azuredevops/0.2.1/docs/data-sources/project) | data source |
| [azurerm_key_vault.core](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.azdo_pat](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.8.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azdo_pat_name"></a> [azdo\_pat\_name](#input\_azdo\_pat\_name) | Azure DevOps PAT name that is stored in a azure key-vault | `string` | `"azure-devops-pat"` | no |
| <a name="input_azuredevops_organization"></a> [azuredevops\_organization](#input\_azuredevops\_organization) | The name of the azure devops project | `string` | n/a | yes |
| <a name="input_azuredevops_project"></a> [azuredevops\_project](#input\_azuredevops\_project) | The name of the azure devops project | `string` | n/a | yes |
| <a name="input_core_name"></a> [core\_name](#input\_core\_name) | The name of the core infra | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name for the Azure AD application. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The short name of the location | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | n/a | yes |

## Outputs

No outputs.
